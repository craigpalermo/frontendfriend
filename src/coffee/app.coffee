# module dependencies
express = require('express')
stylus = require('stylus')
nib = require('nib')

compile = (str, path) ->
    stylus(str).set('filename', path).use(nib())

# set up app
app = module.exports = express()

app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.use(express.logger('dev'))
app.use(stylus.middleware( {
            src: __dirname + '/public',
            compile: compile
        } ))
app.use(express.static(__dirname + '/public'))
app.use(express.urlencoded())
app.use(express.json())
app.use(express.bodyParser())

baseConfig = {
                "name": "MySite",
                "version": "0.0.1",
                "private": "true",
                "dependencies": {},
             }

# add dependencies to json
addDepsToJson = (deps, json) ->
    json.dependencies[x] = "*" for x in deps
    json

# GET - home
homeGet = (req, res) ->
    res.render('index', { title : 'Home' })

# bower generator
genBower = (req, res) ->
    deps = (key for key,val of req.body.deps when val is 'bower')
    console.dir(deps)
    json = addDepsToJson(deps, baseConfig)
    json['install'] =
        {
            "path": "src/public/vendor",
            "sources": {
                "jquery-ui": [
                    "bower_components/jquery-ui/ui/jquery-ui.js",
                    "bower_components/jquery-ui/themes/base/jquery-ui.css"
                ]
            }
        }
    res.json(json)

# npm generator
genNPM = (req, res) ->
    deps = (key for key,val of req.body.deps when val is 'npm')
    console.dir(deps)
    json = addDepsToJson(deps, baseConfig)
    json['scripts'] =   {
                        "postinstall": "bower install && bower-installer",
                        "start": "node app.js"
                        }
    res.json(json)

# Routes
app.get('/', homeGet)
app.post('/', genBower)
app.post('/generate_bower', genBower)
app.post('/generate_npm', genNPM)

# listen server on port 3000
app.listen(3000)
