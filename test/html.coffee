{exec} = require('child_process')
should = require('should')
webMaster = require('./web-master')

curlTest = (uri, eql, callback = ->) ->
  exec "curl http://localhost:3011#{uri}", (err, stdout) ->
    return done(err) if err?
    stdout.trim().should.eql(eql)
    callback()

describe 'web#html', ->
  before (done) ->
    webMaster.run('html', done)

  it 'should get ok on homepage', (done) ->
    curlTest('', 'ok', done)

  it 'should get UserIndex on /user', (done) ->
    curlTest('/user', '<h1>UserIndex</h1>', done)

  it 'should get 404 on /404', (done) ->
    curlTest('/404', '404 not found!', done)

  it 'should get 500 on /500', (done) ->
    curlTest('/500', '500 server error!', done)

  after (done) ->
    webMaster.die(done)