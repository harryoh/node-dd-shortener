# DD URL Shortener
URL Shortener using NodeJS.  
This project was started from [generator-coffee-fullstack](https://github.com/harryoh/generator-coffee-fullstack).

master: [![Build Status](https://travis-ci.org/harryoh/node-dd-shortener.svg?branch=master)](http://travis-ci.org/harryoh/node-dd-shortener) develop: [![Build Status](https://travis-ci.org/harryoh/node-dd-shortener.svg?branch=develop)](http://travis-ci.org/harryoh/node-dd-shortener)

#### Install Environment
```
$ sudo apt-get install gcc nodejs mongodb redis ruby
$ npm install -g grunt-cli
$ gem install sass
```

#### Grunt Serve
```
$ git clone https://github.com/harryoh/node-dd-shortener
$ cd node-dd-shortener
$ bower install
$ npm install
$ cd node_module/geoip-lite
$ npm run-script updatedb
$ cd ../..
$ grunt serve
```

#### Build
```
$ grunt build
$ cd dist
$ NODE_ENV=production npm install
$ cd node_module/geoip-lite
$ npm run-script updatedb
$ cd ../..
$ NODE_ENV=production npm start
```

#### Benchmark

```
$ ab -n 1000 http://localhost:9000/JyegOp
```

Cache Configuration

```
# server/config/environment/index.coffee

.
.
useRedis: true

useLru: true
.
.


```

* Requests per second

|     |   No Cache   |     LRU      |    Redis     |  LRU + Redis  |
|-----|--------------|--------------|--------------|---------------|
|  1  | 256.60 times | 315.09 times | 304.27 times | 322.53 times  |
|  2  | 249.84 times | 435.98 times | 414.80 times | 435.63 times  |
|  3  | 283.43 times | 381.18 times | 360.94 times | 388.10 times  |
|  4  | 248.32 times | 438.30 times | 416.58 times | 448.97 times  |
|  5  | 286.90 times | 377.60 times | 360.34 times | 382.03 times  |

* Time per request

|     | No Cache |   LRU    |  Redis   | LRU + Redis |
|-----|----------|----------|----------|-------------|
|  1  | 3.897 ms | 3.174 ms | 3.287 ms |  3.101 ms   |
|  2  | 4.003 ms | 2.294 ms | 2.411 ms |  2.296 ms   |
|  3  | 3.528 ms | 2.623 ms | 2.771 ms |  2.577 ms   |
|  4  | 4.027 ms | 2.282 ms | 2.401 ms |  2.227 ms   |
|  5  | 3.485 ms | 2.648 ms | 2.775 ms |  2.618 ms   |


### API

#### Shorten a long URL
- **Endpoint**: `/api/1.0/url`
- **Method**: `POST`
- **Parameter**: `longUrl=<string>`

**Request**
```
POST http://url.5004.pe.kr/api/1.0/url
Content-Type: application/json

{"longUrl": "http://5004.pe.kr/"}
```

**Response**


#### Expand a short URL
- **Endpoint**: `/api/1.0/url`
- **Method**: `GET`
- **Parameter**: `shortUrl=<string>`

**Request**
```
GET http://url.5004.pe.kr/api/1.0/url?shortUrl=http://url.5004.pe.kr/A5tamk
```

**Response**


#### URL analytics
- **Endpoint**: `/api/1.0/url/list`
- **Method**: `GET`

**Request**  
```
GET http://url.5004.pe.kr/api/1.0/url/list
```

**Response**


**Request**  
```
GET http://url.5004.pe.kr/api/1.0/history
```

**Response**
