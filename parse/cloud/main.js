//Twilio
Parse.Cloud.define("verifyNum", function(request, response) {
  var twilio = require('twilio')('AC908eebcf092ee13d9db6fa67d71b38dc', '63ebb7a9828cd15dce79a6658092def4');
	twilio.sendSms({
    	to: request.params.number, 
    	from: '+16145154079',
    	body: request.params.message
  },{
      success: function(httpResponse) {
        response.success("sendSms success");
      },
      error: function(httpResponse) {
        response.error("sendSms error");
      }
  });
});


//Stripe
var Stripe = require('stripe');
Stripe.initialize('sk_test_4TyIk8adGJTfvHq9YDt4raCx');

Parse.Cloud.define("createCharge", function(request, response) {
  Stripe.Charges.create({
    amount: 100 * request.params.amount, // $10 expressed in cents
    currency: "usd",
    card: request.params.token
    // customer: request.params.customerId //add comma to line before
  }, {
    success: function(httpResponse) {
      response.success("Charges success!");
    },
    error: function(httpResponse) {
      response.error("Charges fail");
    }
  });
});

Parse.Cloud.define("createCustomer", function(request, response) {    
  Stripe.Customers.create({
    account_balance: 0,
    email: request.params.email,
    description: 'new stripe user',
    metadata: {
      name: request.params.name,
      userId: request.params.objectId, // e.g PFUser object ID
      createWithCard: false
    }
  }, {
    success: function(httpResponse) {
        response.success(customerId); // return customerId
    },
    error: function(httpResponse) {
        console.log(httpResponse);
        response.error("Cannot create a new customer.");
    }
  });
});