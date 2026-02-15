# Rate-limiting:

The objective of this task is to protect backend from excessive traffic.

Firstly modified the configuration:

Added 
```
limit_req_zone $binary_remote_addr zone=api_limit:10m rate=5r/s;
```
to nginx.config file

So that,
- Use client IP ($binary_remote_addr) to track rate
- Create a zone called api_limit
- 10 MB space for tracking IPs
- Allow 5 requests per second per IP


Then added this  in location/ in the file nginx.config file
```
limit_req zone=api_limit burst=10 nodelay;
```
which allow bursts of 10 requests instantly,after that, rate limit applies strictly, excess requests get HTTP 429 Too Many Requests

Checking the ratelimiting:

```
for i in {1..20}; do curl -I localhost; done
```
It sends 20 HTTP HEAD requests to local server.

Requests hit Nginx first.
Nginx performs rate limiting before forwarding to upstream servers.
If within threshold, it load balances across multiple Rails containers.
If rate exceeded, Nginx rejects the request with 429 without forwarding it to the backend.
This protects backend services from overload.

