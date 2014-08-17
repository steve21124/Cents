Parse.Cloud.define("verifyNum", function(request, response) {
  var twilio = require('twilio')('AC908eebcf092ee13d9db6fa67d71b38dc', '63ebb7a9828cd15dce79a6658092def4');
	twilio.sendSms({
    	to: request.params.number, 
    	from: '+16145154079',
    	body: request.params.message
  },{
      success: function(httpResponse) {
        response.success(httpResponse.message);
      },
      error: function(httpResponse) {
        response.error(httpResponse.message);
      }
  });
});


var Stripe = require('stripe');
Stripe.initialize('sk_test_4TyIk8adGJTfvHq9YDt4raCx');

Parse.Cloud.define("createCustomer", function(request, response) {   
  Stripe.Customers.create({
    account_balance: 0,
    description: request.params.phoneNumber,
    card: request.params.token
  }, {
    success: function(httpResponse) {
      response.success(httpResponse);
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
    customer: request.params.customer
  }, {
    success: function(httpResponse) {
      response.success(httpResponse.id);
    },
    error: function(httpResponse) {
      response.error(httpResponse.message);
    }
  });
});

// Parse.Cloud.define("createRecipient", function(request, response) {
//   Stripe.Recipients.create({
//     name: request.params.name,
//     type: "individual",
//     card: request.params.token
//   }, {
//     success: function(httpResponse) {
//       response.success(httpResponse.id);
//     },
//     error: function(httpResponse) {
//       response.error(httpResponse.message);
//     }
//   });
// });

// Parse.Cloud.define("createTransfer", function(request, response) {
//   Stripe.Transfers.create({
//     amount: 100 * request.params.amount,
//     currency: "usd",
//     recipient: request.params.recipient
//   }, {
//     success: function(httpResponse) {
//       response.success(httpResponse.id);
//     },
//     error: function(httpResponse) {
//       response.error(httpResponse.message);
//     }
//   });
// });


Parse.Cloud.define("customRecipient", function(request, response) {
  Parse.Cloud.httpRequest({
    method:"POST",
    url: "https://sk_test_4TyIk8adGJTfvHq9YDt4raCx:@api.stripe.com/v1/recipients",
    body: "card="+request.params.token+"&"+"name="+request.params.name+"&"+"type=individual",
    success: function(httpResponse) 
    {
      response.success(httpResponse.message);//.text
    },
    error: function(httpResponse) 
    {
      response.error('Request failed with response code ' + httpResponse.status);
    }
  });
});