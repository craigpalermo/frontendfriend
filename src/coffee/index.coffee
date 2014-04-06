openLaunchBox = ->
    vex.dialog.open
        message: $("#launch_box").html(),
        showCloseButton: true,
        contentCSS: { width: '55%' },
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
                contentCSS: { width: '50%' },
            $('pre code').each (i, e) -> hljs.highlightBlock(e)
    })

toggleSquareBackground = ->
    $square = $(this)
    $(this).children(':checkbox').each ->
        $(this).prop("checked", !$(this).prop("checked"))
        if $(this).is(":checked")
            $(this).parent().toggleClass("inner_square selected_square")
        else
            $(this).parent().toggleClass("selected_square inner_square")

jQuery ($) ->
    $("#launch_button").on 'click', openLaunchBox
    $(".inner_square").on 'click', toggleSquareBackground
