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
            src: __dirname + '/styl' ,
            dest: __dirname + '/public/css',
            compile: compile
        } ))
app.use(express.static(__dirname + '/public'))
app.use(express.urlencoded())
app.use(express.json())

# home page
home = (req, res) ->
    res.render('index-new', { title : 'Home' })

app.get('/', home)

# listen server on port 3000
app.listen(3000)
