# Authorize.net Perl Integration

A Perl script for processing credit card transactions and creating recurring billing subscriptions through Authorize.net's payment gateway.

## Features

- Credit card processing through Authorize.net
- Support for recurring billing/subscriptions
- XML-based API integration
- Error handling and response processing
- Secure HTTPS communication

## Prerequisites

- Perl 5.x or higher
- Required Perl modules:
  - LWP::UserAgent
  - HTTP::Request::Common
  - POSIX
- Valid Authorize.net credentials:
  - API Login ID
  - Transaction Key

## Configuration

1. Replace the placeholder credentials in the script:
```perl
$authorize_api_login = "*********************************";
$authorize_api_key   = "*********************************";
```

2. Set the appropriate gateway URL:
```perl
$post_url = "https://secure.authorize.net/gateway/transact.dll";
```

## Usage

### Processing a Single Transaction

```perl
ProcessCreditCardAtAuthorizeNet(
    $cardnumber,    # Credit card number
    $expiremonth,   # Expiration month
    $expireyear,    # Expiration year
    $amount,        # Transaction amount
    $ordernum,      # Order number
    $description,   # Transaction description
    $lastname,      # Customer last name
    $firstname,     # Customer first name
    $email,         # Customer email
    $address,       # Billing address
    $city,         # Billing city
    $state,        # Billing state
    $zip,          # Billing zip
    $country       # Billing country
);
```

### Response Handling

The script includes three main response handling functions:
- `GetResponseData`: Processes the raw API response
- `HandleResponseData`: Processes successful transactions
- `HandleFailure`: Manages failed transactions

## Security Considerations

⚠️ **Important Security Notes:**

1. Never store raw credit card data in your database
2. Ensure PCI compliance when handling credit card data
3. Use HTTPS for all transactions
4. Sanitize all input data before processing
5. Keep API credentials secure and never commit them to version control
6. Implement proper error logging
7. Use environment variables for sensitive credentials

## Error Handling

The script includes basic error handling for:
- Failed API connections
- Invalid responses
- Transaction processing errors

Error messages are stored in `$AN_response_reason_text`.

## Testing

Before using in production:
1. Test with Authorize.net's sandbox environment
2. Verify error handling
3. Test recurring billing setup
4. Validate response processing

## Authorize.net Documentation

For more information about the Authorize.net API:
- [Authorize.net Developer Center](https://developer.authorize.net/)
- [API Documentation](https://developer.authorize.net/api/reference/index.html)
- [XML Schema Documentation](https://developer.authorize.net/api/reference/schema.html)

## License

This code is released under the MIT License. See LICENSE file for details.

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## Support

For issues with the script, please open a GitHub issue. For Authorize.net API issues, contact their support directly.

## Disclaimer

This code is provided as-is. Ensure proper testing and security measures before using in a production environment. The authors are not responsible for any misuse or security breaches.
