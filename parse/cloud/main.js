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

Parse.Cloud.define("createCustomer", function(request, response) {   
  Stripe.Customers.create({
    account_balance: 0,
    description: request.params.phoneNumber,
    card: request.params.token
  }, {
    success: function(httpResponse) {
      response.success(httpResponse.id);
    },
    error: function(httpResponse) {
      response.error(httpResponse.message);
    }
  });
});

Parse.Cloud.define("createCharge", function(request, response) {
  Stripe.Charges.create({
    amount: 100 * request.params.amount,
    currency: "usd",
    customer: request.params.customerId
  }, {
    success: function(httpResponse) {
      response.success(httpResponse.message);
    },
    error: function(httpResponse) {
      response.error(httpResponse.message);
    }
  });
});