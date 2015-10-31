# DD URL Shortener
URL Shortener using NodeJS.  
This project was started from [generator-coffee-fullstack](https://github.com/harryoh/generator-coffee-fullstack).

#### Install Environment
```
$ sudo apt-get install gcc nodejs mongodb redis ruby
$ npm install -g grunt-cli
$ gem install sass
```

#### Using
```
$ git clone https://github.com/harryoh/node-dd-shortener
$ cd node-dd-shortener
$ bower install
$ npm install
$ grunt serve
```

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

#### URL List
- **Endpoint**: `/api/1.0/list`
- **Method**: `GET`

#### Short URL analytics
- **Endpoint**: `/api/1.0/url`
- **Method**: `GET`
- **Parameter**: `shortUrl=<string>`

**Request**  
```
GET http://url.5004.pe.kr/api/1.0/url?shortUrl=http://url.5004.pe.kr/A5tamk
```

**Response**
