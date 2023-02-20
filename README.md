# credUP

## Inspiration

One of the main inspirations for building our project for the hackathon was the growing popularity of Venmo. With over 75 million users in 2022, it's clear that people are increasingly comfortable with using digital platforms to manage their finances. As frequent users of Venmo ourselves, we noticed that most transactions on the app were made using debit cards or bank accounts, which don't have any impact on a person's credit score.

This led us to think about the importance of building credit, especially for young individuals who are just starting to build their financial independence. We realized that there wasn't a platform that specifically catered to this demographic, which is why we decided to create a similar platform that would encourage and support the use of credit cards to build credit.

## What we do

Our app is designed to help young individuals build their credit score in a simple and effective way. Once a user connects their credit card and bank account to our app, the process is straightforward.

When a user sends a transaction to a friend through our app, we charge their credit card for the transaction amount. If the credit card is successfully charged, our app then uses the bank account on file to immediately pay off the credit card balance. This process treats the credit card like a debit card, ensuring that the user is using their credit responsibly and not accumulating any debt.

Once the credit card has been paid off, the amount that was charged earlier is then sent to the user's friend, who can redeem it without having to create an account with us. We understand that not everyone will be using our app (i.e. they’re not focused on building their credit), so we've made the redemption process as simple as possible.

Our app offers a seamless and secure way for young individuals to use their credit cards responsibly and build their credit score in the process. By making the process of using credit cards as easy and safe as possible, we hope to encourage more young people to establish good credit habits early on, which will set them up for financial success in the long run.

## How we built it

To build our app, we wanted to create a familiar mobile app experience for the user, so we decided to develop it as a mobile app for iOS devices using Xcode for the frontend. For the backend, we used a variety of technologies including MongoDB, NodeJS, Express, Checkbook, Stripe, and Selenium/Python.

The payment system we built using our app required the use of several different APIs. Assuming the user had enough funds in their bank account, we would first use the Stripe API to charge the user's credit card for the transaction amount. We then held onto that amount in our account.

Next, assuming the charge was successful, we used a script built with Selenium and Python to automatically pay off the credit card we just used from the money within the bank account. Finally, we use the funds we were holding from earlier and send the intended recipient their payment using the Checkbook.io API. This allows our recipients to receive their payment without having to create an account with us, thus eliminating any potential barriers to using our platform.

## Challenges

One of the main challenges we faced during the development of our app was determining the best way to move money around while achieving our goals. We encountered some difficulties with our initial model, which assumed that Checkbook.io could be used to process credit card payments. However, we quickly discovered that Checkbook.io would only be best for ACH payments on our platform, so we had to pivot and restructure our diagram multiple times before finding a solution that would work for our app while still reaping the benefits of the Checkbook.io API that allowed our recipients to be anyone.

Another challenge we encountered was related to our frontend development. Initially, we tried using ReTool for the frontend, but we found it to be too limiting for our needs. As a result, we made the decision to restart our frontend development halfway through the competition and ended up using Xcode instead, which allowed us greater flexibility and control over the user experience.

## Accomplishments that we're proud of

As a first-time hackathon team, we are incredibly proud of what we were able to accomplish in just 36 hours. Despite not having worked together before, we collaborated effectively as a team, and learned new technologies on the fly in order to bring our vision to life.

One of our biggest accomplishments was coming up with a unique idea for our app that we are passionate about, and that we believe has the potential to help people in the future. By creating a platform to help young individuals build their credit score, we hope to make a positive impact on their financial future.

Overall, we are proud of the hard work, creativity, and collaboration that went into building our app, and we are excited to see where this project could go in the future.

## What we learned

We learned so many new things during the hackathon, especially about different technologies and backend frameworks. We had a lot of fun learning and building together, but we also found out that having a balanced team with both frontend and backend developers is important to make sure everything runs smoothly.

Throughout the hackathon, we also discovered the importance of communication and teamwork, and how having a positive attitude and a willingness to adapt can make all the difference. We also really enjoyed attending workshops provided by the sponsors, which helped us to learn more about new technologies and meet other people who share our interests.

All in all, we had a great time at the hackathon, and we are proud of what we accomplished as a team. We're excited to keep learning and building new things in the future!

## What’s next for **CredUP**

We are really excited about the future of CredUP! We see the hackathon as a starting point for a working proof of concept and we hope to keep improving and adding new functionality to make our platform even better. One thing we are considering is adding data management to help users easily track their spending habits and get recommendations to improve their credit score.

Another idea we have is to create parties or groups within the app where it can automatically split the bill, which we think would be really useful for young people who are just starting out and trying to manage their finances.

From a more logistical perspective, we want to explore partnerships with credit card companies that share our goal of helping young people build their credit. We think that by working together, we can create more opportunities for our users and help them reach their financial goals.

Overall, we are excited about the possibilities for CredUP and can't wait to see where this journey takes us!
