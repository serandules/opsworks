var mongoose = require('mongoose');

exports.Release = mongoose.model('Release', {
    type: {type: String, required: true, enum: ['serandules', 'serandomps']},
    name: {type: String, required: true},
    version: {type: String, required: true},
    revision: String
});
