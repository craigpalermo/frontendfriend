mongoose = require('mongoose')

packageSchema = mongoose.Schema({
    package_name: String,
    package_manager: String,
    description: String,
    long_name: String,
    image_path: String,
    type: String
})

Package = mongoose.model('Package', packageSchema)

module.exports = { Package : Package }
