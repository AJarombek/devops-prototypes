/**
 * Create an AWS Lambda function that converts an integer to a roman numeral
 * @author Andrew Jarombek
 * @since 8/29/2018
 */

exports.handler = (event, context, callback) => {

    const resp = "Hello";

    // The entire response object must be returned - otherwise API Gateway will complain
    // about a malformed Lambda proxy response - https://bit.ly/2oAk52G
    callback(null, {
        statusCode: '200',
        body: JSON.stringify({'response': resp}),
        headers: {
            'Content-Type': 'application/json'
        }
    });
};