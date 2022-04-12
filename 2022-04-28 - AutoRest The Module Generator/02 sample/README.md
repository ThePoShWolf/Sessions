# Basic REST call

## Parameters as body

```plaintext
POST https://portal.runway.host/api/v2/auth/login HTTP/1.1
Host: portal.runway.host
Authorization: Session
Content-Type: application/json
Content-Length: 88

{
  "email": "anthony@runway.host",
  "password": "<password>",
  "remember": true
}
```

## Parameters as Query

```plaintext
POST https://portal.runway.host/api/v2/auth/login?email=anthony@runway.host&password=<password>&remember=true HTTP/1.1
Host: portal.runway.host
Authorization: Session
Content-Type: application/json
Content-Length: 88
```