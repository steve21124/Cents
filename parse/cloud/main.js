// var twilio = require('twilio')('AC908eebcf092ee13d9db6fa67d71b38dc', '63ebb7a9828cd15dce79a6658092def4');

// Parse.Cloud.define("verifyNum", function(request, response) {
//   twilio.sendSMS({
//     From: "+16145154079",
//     To: request.params.number,
//     Body: request.params.message
//   }, {
//     success: function(httpResponse) { response.success("SMS sent!"); },
//     error: function(httpResponse) { response.error("Had problem sending SMS via Twilio - coming from main.js"); }
//   });
// });



var client = require('twilio')('AC908eebcf092ee13d9db6fa67d71b38dc', '63ebb7a9828cd15dce79a6658092def4');

Parse.Cloud.define("verifyNum", function(request, response) {
  client.sendSms({
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