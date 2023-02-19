const express = require('express');
const app = express();
const http = require('http');
const bodyParser = require("body-parser");
const fs = require("fs")
const axios = require('axios')
const apn = require('apn');
const MongoClient = require('mongodb').MongoClient
const stripe = require("stripe")('sk_test_51Md6mYEwxbGRW5vXTshfQSnQSoMV6zwOXoLwtW8pFYOyx5OaLi2G6Otzi5Jqu7jb8nLqTGNKrMnXlzEWkB8AegxZ00DlpUCfXq')
var CheckbookAPI = require('checkbook-api');
var Checkbook = new CheckbookAPI({
    api_key: 'ca4ed6219506d48b5d261f5550c3a6b5',
    api_secret: 'd5d231e41e03f5536a2f46401d1a1d5e',
    env: 'sandbox'
});

app.use(bodyParser.json());


var url = "mongodb+srv://admin:ocG8kH607FdYggQe@cluster0.hyymvdx.mongodb.net/?retryWrites=true&w=majority";
MongoClient.connect(url, { useUnifiedTopology: true }).then(client => {
	  
	app.get('/credit/getStatus', function(req, res) {
		let rawdata = fs.readFileSync('test.json');
		let jsonData = JSON.parse(rawdata);
		res.send(jsonData)
	});
    
    app.post('/credit/addBankAccount', function(req, res) {
        let userID = req.headers["id"]
        let routing = req.headers["routing"]
        let account = req.headers["account"]
        
        Checkbook.banks.addBankAccount({
            routing: routing,
            account: account,
            type: 'CHECKING'
        }, function (error, response) {
            if (error) {
                // Adding bank unsuccessful
                error["status"] = -1
                res.send(error)
            } else {
                db = client.db("creditDB")
                col = db.collection("users")
            
                col.findOne( { '_id': userID }, function(err, document) {
                    if (document == null) {
                        res.send({"status": -1, "err": "User with that ID does not exist."})
                        return
                    } else {
                        col.updateOne({ '_id': userID }, { $set: { "bankAccount": {"routingNumber": routing, "accountNumber": account} } })
                        res.send({"status": 0, "task": "bank account added"})
                    }
                })
            }
        });qw
    })
    
    app.post('/credit/makePayment', function(req, res) {
        
        // Pull values from the headers
        let recName = req.headers["recname"]
        let recEmail = req.headers["recemail"]
        let amount = parseInt(req.headers["amount"])
        let userID = req.headers["id"]
        let isPublic = (req.headers["isPublic"] == 'true')
        let message = req.headers["message"]
        
        // Make payment with checkbook.io
        Checkbook.checks.sendDigitalCheck({
            name: recName,
            recipient: recEmail,
            description: message,
            amount: amount
        }, function (error, response) {
            if (error) {
                // Payment unsuccessful
                error["status"] = -1
                res.send(error)
            } else {
              // Payment successful, make payment document
              db = client.db("creditDB")
              col = db.collection("payments")

              let date = new Date()
                let paymentDocument = {
                  "_id": makeid(15),
                    "userid": userID,
                  "amount": amount,
                    "recemail": recEmail,
                  "isPublic": true,
                  "message": message,
                  "pending": true,
                  "paymentDate": date,
                  "name": recName
                }

              col.insertOne(paymentDocument)
              res.send({"status": 0, "task": "payment made", "pendingPaymentDoc": paymentDocument["_id"]})
            }
        });
    });
    
    function makeid(length) {
        let result = '';
        const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        const charactersLength = characters.length;
        let counter = 0;
        while (counter < length) {
          result += characters.charAt(Math.floor(Math.random() * charactersLength));
          counter += 1;
        }
        return result;
    }
    
    app.post('/credit/logPayment', function(req, res) {
        
        // Pull values from the headers
        let success = (req.headers["success"] == 'true')
        let paymentID = req.headers["paymentid"]
        
        db = client.db("creditDB")
        col = db.collection("payments")
        
        col.findOne( { '_id': paymentID }, function(err, document) {
            if (document == null) {
                res.send({"status": -1, "err": "Document with that paymentID does not exist."})
                return
            }
        })
        
        let date = new Date()
        col.updateOne({ '_id': paymentID }, { $set: { "pending": false, "paymentDate": date } })
        if (success) {
            // Update payment collection with a non-pending status
            col.findOne( { '_id': paymentID }, function(err, document) {
        	  	col = db.collection("completedPayments")
                col.insertOne(document)
                col = db.collection("payments")
                col.deleteOne( { _id: paymentID } )
        		res.send({"status": 0, "task": "completed payment moved"})
            })
    		res.send({"status": 0, "task": "payment updated"})
        } else {
            // Log payment under failedPayment collection and remove from payment collection
            col.findOne( { '_id': paymentID }, function(err, document) {
        	  	col = db.collection("failedPayments")
                col.insertOne(document)
                col = db.collection("payments")
                col.deleteOne( { _id: paymentID } )
        		res.send({"status": 0, "task": "failed payment moved"})
            })
        }
        
    });
    
    app.get('/credit/getPublicPayments', function(req, res) {
        db = client.db("creditDB")
        col = db.collection("payments")
        
        const options = {
            sort: { date: 1 }
        };
        
        col.find( { 'isPublic': true }, options ).toArray(function(err, document) {
            res.send({"publicTransactions": document})
        })
    })
    
    const calculateOrderAmount = (items, amount) => {
        // Replace this constant with a calculation of the order's amount
        // Calculate the order total on the server to prevent
        // people from directly manipulating the amount on the client
        return parseInt(amount) * 100;
    };
    
    app.post("/credit/create-payment-intent", async (req, res) => {
        const { items } = req.body;
        amount = req.headers["amount"]

        // Create a PaymentIntent with the order amount and currency
        const paymentIntent = await stripe.paymentIntents.create({
            amount: calculateOrderAmount(items, amount),
            currency: "usd",
            automatic_payment_methods: {
            enabled: true,
            },
        });

        res.send({
            clientSecret: paymentIntent.client_secret,
        });
    });

	const httpServer = http.createServer(app);

	httpServer.listen(6900, () => {
		console.log('HTTP Server running on port 6900');
	});
	
}).catch(error => console.error(error))