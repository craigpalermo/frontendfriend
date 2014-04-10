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

app.configure( ->
    app.use(express.logger('dev'))
    app.use(stylus.middleware( {
                src: __dirname + '/public',
                compile: compile
            } ))
    app.use(express.static(__dirname + '/public'))
    app.use(express.urlencoded())
    app.use(express.json())
    app.use(express.bodyParser())
)

# base configuration used for npm and bower
baseConfig = {
                "name": "MySite",
                "version": "0.0.1",
                "private": "true",
                "dependencies": {},
             }

# add dependencies to json
addDepsToJson = (deps, json) ->
    json.dependencies[x] = "*" for x in deps
    return json

# bower generator
genBower = (req, res) ->
    deps = (key for key,val of req.body.deps when val is 'bower')
    json = addDepsToJson(deps, JSON.parse(JSON.stringify(baseConfig)))
    json['install'] =
        {
            "path": "src/public/vendor"
        }
    res.json(json)

# npm generator
genNPM = (req, res) ->
    deps = (key for key,val of req.body.deps when val is 'npm')
    json = addDepsToJson(deps, JSON.parse(JSON.stringify(baseConfig)))
    json['scripts'] =   {
                        "postinstall": "bower install && bower-installer",
                        "start": "node app.js"
                        }
    res.json(json)

# set up mongoose connection
mongoose = require('mongoose')
mongoose.connect('mongodb://localhost/fef')

db = mongoose.connection
db.on('error', console.error.bind(console, 'connection error:'))
db.once('open', -> # callback for db open is below
    packageSchema = mongoose.Schema({
        package_name: String,
        package_manager: String,
        description: String,
        long_name: String,
        image_path: String,
        type: String
    })

    Package = mongoose.model('Package', packageSchema)
    
    # GET - home
    homeGet = (req, res) ->
        Package.find({type: /^framework/ }, (err, frameworks) ->
            Package.find({type: /^markdown/ }, (err, markdowns) ->
                Package.find({type: /^library/ }, (err, libraries) ->
                    res.render("index.jade", {
                        title: "Home",
                        frameworks: frameworks,
                        markdowns: markdowns,
                        libraries: libraries
                    })
                )
            )
        )

    # GET - add new package
    addPackageGet = (req, res) ->
        res.render('add_package', {})

    # POST - add new package
    addPackagePost = (req, res) ->
        pac = new Package(  {
                                package_name: req.body.package_name,
                                package_manager: req.body.package_manager,
                                description: req.body.description,
                                long_name: req.body.long_name,
                                image_path: req.body.image_path,
                                type: req.body.type
                            }
        )
        pac.save( (err, pac) ->
            if (err) then console.error(err)
        )
        res.render('add_package', {})

    # Routes
    app.get('/', homeGet)
    app.get('/add_package', addPackageGet)
    app.post('/generate_bower', genBower)
    app.post('/generate_npm', genNPM)
    app.post('/add_package', addPackagePost)

    # listen server on port 3000
    app.listen(3000)
)
