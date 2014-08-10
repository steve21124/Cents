//Twilio
Parse.Cloud.define("verifyNum", function(request, response) {
  var twilio = require('twilio')('AC908eebcf092ee13d9db6fa67d71b38dc', '63ebb7a9828cd15dce79a6658092def4');
	twilio.sendSms({
    	to: request.params.number, 
    	from: '+16145154079',
    	body: request.params.message
  }, function(err, responseData) { 
    	if (err) {
     	 	console.log(err);
    	} else { 
      	console.log(responseData.from); 
      	console.log(responseData.body);
    	}
  });
});


//Stripe
  var stripe = require("stripe")("sk_test_4SpEeezTvwavaY6qZ8r6h45w");

Parse.Cloud.define("createCustomer", function(request, response) {
  // var stripe = require("stripe")("sk_test_4SpEeezTvwavaY6qZ8r6h45w");
	stripe.customers.create({
	  	card: request.params.cardToken,
	  	description: request.params.phoneNumber
  }, function(err, responseData) { 
      if (err) {
        console.log(err);
      } else { 
        console.log(responseData.from); 
        console.log(responseData.body);
      }
  });
});

Parse.Cloud.define("createCharge", function(request, response) {
  // var stripe = require("stripe")("sk_test_4SpEeezTvwavaY6qZ8r6h45w");
	stripe.charges.create({
		amount: request.params.amount, // amount in cents, again
		currency: "usd",
		customer: request.params.customerId
  }, function(err, responseData) { 
      if (err) {
        console.log(err);
      } else { 
        console.log(responseData.from); 
        console.log(responseData.body);
      }
  });
});