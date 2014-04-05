module.exports = function(grunt) {
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-express-server');

    grunt.initConfig({
        express: {
            dev: {
                options: {
                    script: 'src/app.js'
                }
            },
        },
        watch: {
            express: {
                files:  [ '**/*.js' ],
                tasks:  [ 'express:dev' ],
                options: {
                    spawn: false
                }
            },
            livereload: {
                files: ['src/styl/*',
                        'src/public/css/*',
                        'src/public/js/*',
                        'src/views/*',
                       ],
                options: { livereload: true },
            },
            coffee: {
                files: ['src/coffee/*.coffee'],
                tasks: ['coffee:compile']
            }
        },
        coffee: {
            compile: {
                expand: true,
                flatten: true,
                cwd: "src/coffee/",
                files: [
                    {src: 'src/coffee/app.coffee', dest: 'src/app.js'},
                    {src: 'src/coffee/index.coffee', dest: 'src/public/js/index.js'}
                ],
                ext: '.js'
            }
        }
    });

    grunt.registerTask('server', ['express:dev', 'watch'])
};
