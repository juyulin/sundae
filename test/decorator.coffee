should = require 'should'
express = require 'express'
supertest = require 'supertest'

ensure = require '../lib/decorators/ensure'
beforeAction = require '../lib/decorators/before'
select = require '../lib/decorators/select'
afterAction = require '../lib/decorators/after'
request = require '../lib/request'
response = require '../lib/response'

describe 'Decorators#Ensure', ->

  app = express()

  before -> request.config app, (req) -> req.allowedKeys = ['name', 'lang']

  it 'should callback error when params not meet ensures', (done) ->
    app.use (req, res) ->
      req.set 'name', 'hi'
      ensure('name _sessionUserId') req, res, (err) -> should(err).not.eql null
      res.end 'ok'

    supertest(app).get('/').end done

  it 'should not callback error when meet all params', (done) ->
    app.use (req, res) ->
      req.set 'name', 'hi'
      req.set 'lang', 'en'
      ensure('name lang') req, res, (err) -> should(err).eql null
      res.end 'ok'

    supertest(app).get('/').end done

  after -> request.config app, (req) -> req.allowedKeys = []

describe 'Decorators#Before', ->

  app = express()

  before -> request.config app, (req) -> req.allowedKeys = ['name']

  it 'should callback error when use ensureMember before hook', (done) ->
    app.use (req, res) ->
      req.set 'name', 'Grace'
      req._ctrl =
        upper: (req, res, next) ->
          req.set('name', req.get('name').toUpperCase())
          next()
      beforeAction('upper') req, res, (err) ->
        req.get('name').should.eql 'GRACE'
      res.end 'ok'

    supertest(app).get('/').end done

  after -> request.config app, (req) -> req.allowedKeys = []

describe 'Decorators#Assembler', ->

  it 'should call the after function and get a new property', (done) ->
    app = express()
    app.use (req, res) ->
      req._ctrl =
        isNew: (req, result, callback) ->
          result.isNew = true
          callback()
      afterAction('isNew') req, res, {}, (err, result) ->
        result.should.have.properties 'isNew'
      # also work when result is array
      afterAction('isNew') req, res, [{}, {}], (err, results) ->
        results.forEach (result) -> result.should.have.properties 'isNew'
      res.end 'ok'
    supertest(app).get('/').end done

describe 'Decorators#Select', ->

  it 'should pick fields and ignore others', ->
    result =
      id: '123'
      name: 'Grace'
      updatedAt: '2014-02-24T03:50:00.841Z'
    select('id updatedAt other') {}, {}, result, (err, result) ->
      result.should.have.keys 'id', 'updatedAt'

  it 'should omit fields', ->
    result =
      name: 'Grace'
      password: '123456'
      updatedAt: '2014-02-24T03:50:00.841Z'
    select('-password') {}, {}, result, (err, result) ->
      result.should.have.keys 'name', 'updatedAt'
