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
    submitForm '/generate_npm'

submitBowerForm = ->
    submitForm '/generate_bower'

submitForm = (url) ->
    $.ajax({
        type: 'POST',
        url: url,
        data: $("#package_form").serialize(),
        success: (data) ->
            vex.dialog.open
                message: ("<pre><code>" +
                           JSON.stringify(data, null, 4) +
                           "</code></pre>")
                showCloseButton: true,
                contentCSS: { width: '45%' },
            $('pre code').each (i, e) -> hljs.highlightBlock(e)
    })

jQuery ($) ->
    $("#launch_button").on 'click', openLaunchBox
