# README
😄
This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
ruby-2.7.1

* System dependencies

* Configuration
    API host

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

`rails s`

* Deploy

`SERVER=35.194.129.109 cap production deploy`

# api-dtl
DTL 的整合搜尋引擎
- Cofact: https://a.doublethinklab.org/cofact?&q=Taiwan
- db-dtl: https://a.doublethinklab.org/dtl?&q=Taiwan&start_date=2021-01-01&end_date=2021-01-02
- media: https://a.doublethinklab.org/media?&q=Taiwan&start_date=2021-01-01&end_date=2021-01-02
- Picasso: https://a.doublethinklab.org/pablo?&q=Taiwan&start_date=2021-01-01&end_date=2021-01-02

另有與 ct-importer https://github.com/doublethinklab/ct-importer 相依的功能
- Twitter, FB, YT 的爬蟲，打完之後會送資料進 db-dtl

# log
