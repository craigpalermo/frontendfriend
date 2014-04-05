openLaunchBox = ->
    vex.dialog.open
        message: $("#launch_box").html(),
        showCloseButton: true,
        contentCSS: { width: '50%' },
        buttons: [
            $.extend({},
                vex.dialog.buttons.NO,
                {
                    className: 'vex-dialog-button-primary',
                    text: 'Get NPM Config',
                    click: submitNpmForm
                }
            ),
            $.extend({},
                vex.dialog.buttons.NO,
                {
                    className: 'vex-dialog-button-primary',
                    text: 'Get Bower Config',
                    click: submitBowerForm
                }
            )
        ]

submitNpmForm = ->
    console.log "NPM"

submitBowerForm = ->
    console.log "Bower"

jQuery ($) ->
    $("#launch_button").on 'click', openLaunchBox
