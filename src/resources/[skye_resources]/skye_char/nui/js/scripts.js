let Selected = false
let SelectedChar = null
let SelectedCharInfo = null
let InAddMenu = false
let CurrentGender = null
let CharAmount = 0

StartMultichar = function() {
    $('.multichar-container-loading').fadeIn()
    $.post('https://skye_char/LoadChars')
}

SetupMultichar = function(data) {
    $('.multichar-loading-bar-left').css({'width':'0%'})
    $('.multichar-loading-bar-right').css({'width':'0%'})
    $('.multichar-loading-bar-logo').css({'opacity': '0'})

    setTimeout(function(){
        $('.multichar-container-loading').fadeOut()
        $('.multichar-container-main').fadeIn()
    }, 3500);

    for (const [KeyInfo, ValueInfo] of Object.entries(data.Info)) {
        let NuiString = `
            <div class="multichar-char-`+KeyInfo+` multichar-char-slot" data-char-id="`+ValueInfo['Character']['CitizenId']+`" data-char-firstname="`+ValueInfo['Character']['FirstName']+`" data-char-lastname="`+ValueInfo['Character']['LastName']+`"></div>
        `

        $('.multichar-container-main').append(NuiString)

        $('.multichar-char-'+KeyInfo+'').css({'position': 'absolute'})
        $('.multichar-char-'+KeyInfo+'').css({'left': ''+(ValueInfo['ScreenCoords']['Left'] - 5)+'%'})
        $('.multichar-char-'+KeyInfo+'').css({'top': ''+(ValueInfo['ScreenCoords']['Top'] - 40)+'%'})
        $('.multichar-char-'+KeyInfo+'').css({'width': '10%'})
        $('.multichar-char-'+KeyInfo+'').css({'height': '40%'})

        CharAmount = KeyInfo
    }
}

$(document).on('mouseenter', '.multichar-char-slot', function() {
    let FirstName = $(this).data('char-firstname')
    let LastName = $(this).data('char-lastname')

    let NuiString = `
        <div class="multichar-info-banner-text">`+FirstName+` `+LastName+`</div>
    `

    $('.multichar-button-delete').css({'background-color': '#79150898'})
    $('.multichar-button-play').css({'background-color': '#376d2598'})

    $('.multichar-info-banner').html(NuiString)
})

$(document).on('mouseleave', '.multichar-char-slot', function() {
    if (Selected) {
        let NuiString = `
            <div class="multichar-info-banner-text">`+SelectedCharInfo+`</div>
        `

        $('.multichar-info-banner').html(NuiString)
    } else {
        let NuiString = `
            <div class="multichar-info-banner-text">Kies een karakter</div>
        `
        $('.multichar-button-delete').css({'background-color': 'rgb(88, 88, 88)'})
        $('.multichar-button-play').css({'background-color': 'rgb(88, 88, 88)'})

        $('.multichar-info-banner').html(NuiString)
    }
})

$(document).on('click', '.multichar-char-slot', function() {
    
    let FirstName = $(this).data('char-firstname')
    let LastName = $(this).data('char-lastname')
    let CharId = $(this).data('char-id')
    if (SelectedChar != CharId) {
        let NuiString = `
            <div class="multichar-info-banner-text">`+FirstName+` `+LastName+`</div>
        `

        $('.multichar-button-delete').css({'background-color': '#79150898'})
        $('.multichar-button-play').css({'background-color': '#376d2598'})

        $('.multichar-info-banner').html(NuiString)

        Selected = true
        SelectedChar = CharId
        SelectedCharInfo = ``+FirstName+` `+LastName+``
    } else {
        $('.multichar-loading-bar-left').css({'width':'50%'})
        $('.multichar-loading-bar-right').css({'width':'50%'})
        $('.multichar-loading-bar-logo').css({'opacity': '100'})
        $('.multichar-container-main').fadeOut()

        setTimeout(function(){
            let NuiString = `
            <div class="multichar-container-main">
                <div class="multichar-info-container">
                    <div class="multichar-info-banner">
                        <div class="multichar-info-banner-text">Kies een karakter</div>
                    </div>
                    <div class="multichar-whiteline"></div>
                    <div class="multichar-buttons">
                        <div class="multichar-button-delete"><div class="multichar-button-text">Verwijder</div></div>
                        <div class="multichar-button-play"><div class="multichar-button-text">Speel</div></div>
                    </div>
                </div>


                <div class="mulitchar-options-container">
                    <div class="multichar-option-add"><i class="fa-solid fa-plus"></i></div>
                    <div class="multichar-option-info"><i class="fa-regular fa-circle-question"></i></div>
                    <div class="multichar-option-reload"><i class="fa-solid fa-arrow-rotate-right"></i></div>
                </div>
            </div>
            `

            $('.multichar-container-main').html(NuiString)

            $.post('https://skye_char/LoginSelectedChar', JSON.stringify({CitizenId : SelectedChar}));

            Selected = false
            SelectedChar = null
            SelectedCharInfo = null
        }, 1000);
    }

})

$(document).on('click', '.multichar-button-play', function() {
    if (Selected) {
        $('.multichar-loading-bar-left').css({'width':'50%'})
        $('.multichar-loading-bar-right').css({'width':'50%'})
        $('.multichar-loading-bar-logo').css({'opacity': '100'})
        $('.multichar-container-main').fadeOut()

        setTimeout(function(){
            let NuiString = `
            <div class="multichar-container-main">
                <div class="multichar-info-container">
                    <div class="multichar-info-banner">
                        <div class="multichar-info-banner-text">Kies een karakter</div>
                    </div>
                    <div class="multichar-whiteline"></div>
                    <div class="multichar-buttons">
                        <div class="multichar-button-delete"><div class="multichar-button-text">Verwijder</div></div>
                        <div class="multichar-button-play"><div class="multichar-button-text">Speel</div></div>
                    </div>
                </div>


                <div class="mulitchar-options-container">
                    <div class="multichar-option-add"><i class="fa-solid fa-plus"></i></div>
                    <div class="multichar-option-info"><i class="fa-regular fa-circle-question"></i></div>
                    <div class="multichar-option-reload"><i class="fa-solid fa-arrow-rotate-right"></i></div>
                </div>
            </div>
            `

            $('.multichar-container-main').html(NuiString)

            $.post('https://skye_char/LoginSelectedChar', JSON.stringify({CitizenId : SelectedChar}));

            Selected = false
            SelectedChar = null
            SelectedCharInfo = null
        }, 1000);
    }
})


$(document).on('click', '.multichar-option-add', function() {
    if (CharAmount < 3) {
        $('.multichar-container-main').fadeOut()
        InAddMenu = true
        $('.multichar-container-add').fadeIn()
    }
})

$(document).on('click', '.multichar-add-cancel', function() {
    $('.multichar-container-add').fadeOut(250)
    $('.multichar-container-main').fadeIn(250)  

    InAddMenu = false
    CurrentGender = null

    setTimeout(function() {
        $('.multichar-add-gender-man').css({'filter': 'drop-shadow(1vh .1vh 0.1vh #000000'})
        $('.multichar-add-gender-woman').css({'filter': 'drop-shadow(1vh .1vh 0.1vh #000000'})

        let NuiString = `
            <div class="multichar-add-banner">Kies Geslacht:</div>
            <img class="multichar-add-gender-man" src="./img/male.png">
            <img class="multichar-add-gender-woman" src="./img/female.png">
            <div class="multichar-add-form-firstname">Voornaam <input type="text" name="firstname"></div>
            <div class="multichar-add-form-lastname">Achternaam <input type="text" name="lastname"></div>
            <div class="multichar-add-form-birth">Verjaardag <input name="dob" class="multichar-add-form-birth-form" type="date" value="2000-01-01" max="2090/01/01" /></div>
            <div class="multichar-add-create">Maak</div>
            <div class="multichar-add-cancel">Annuleer</div>
        `

        $('.multichar-container-add').html(NuiString)
    }, 1000)
})

$(document).on('click', '.multichar-add-gender-man', function() {
    CurrentGender = 'man'
    $('.multichar-add-gender-woman').css({'filter': 'drop-shadow(1vh .1vh 0.1vh #000000'})
    $('.multichar-add-gender-man').css({'filter': 'drop-shadow(0vh .1vh 0.1vh #376d2598'})
})

$(document).on('click', '.multichar-add-gender-woman', function() {
    CurrentGender = 'vrouw'
    $('.multichar-add-gender-man').css({'filter': 'drop-shadow(1vh .1vh 0.1vh #000000'})
    $('.multichar-add-gender-woman').css({'filter': 'drop-shadow(0vh .1vh 0.1vh #376d2598'})
})

$(document).on('click', '.multichar-add-create', function() {
    let FirstName = $('.multichar-add-form-firstname input').val()
    let LastName = $('.multichar-add-form-lastname input').val()
    let Birth = $('.multichar-add-form-birth input').val()
    if (FirstName != '' & LastName != '' & CurrentGender != null) {
        $('.multichar-container-main').fadeOut()

        $('.multichar-container-add').fadeOut()  

        InAddMenu = false
    
        setTimeout(function() {
            $('.multichar-add-gender-man').css({'filter': 'drop-shadow(1vh .1vh 0.1vh #000000'})
            $('.multichar-add-gender-woman').css({'filter': 'drop-shadow(1vh .1vh 0.1vh #000000'})
    
            let NuiString = `
                <div class="multichar-add-banner">Kies Geslacht:</div>
                <img class="multichar-add-gender-man" src="./img/male.png">
                <img class="multichar-add-gender-woman" src="./img/female.png">
                <div class="multichar-add-form-firstname">Voornaam <input type="text" name="firstname"></div>
                <div class="multichar-add-form-lastname">Achternaam <input type="text" name="lastname"></div>
                <div class="multichar-add-form-birth">Verjaardag <input name="dob" class="multichar-add-form-birth-form" type="date" value="2000-01-01" max="2090/01/01" /></div>
                <div class="multichar-add-create">Maak</div>
                <div class="multichar-add-cancel">Annuleer</div>
            `
    
            $('.multichar-container-add').html(NuiString)

            let NuiString2 = `
            <div class="multichar-container-main">
                <div class="multichar-info-container">
                    <div class="multichar-info-banner">
                        <div class="multichar-info-banner-text">Kies een karakter</div>
                    </div>
                    <div class="multichar-whiteline"></div>
                    <div class="multichar-buttons">
                        <div class="multichar-button-delete"><div class="multichar-button-text">Verwijder</div></div>
                        <div class="multichar-button-play"><div class="multichar-button-text">Speel</div></div>
                    </div>
                </div>


                <div class="mulitchar-options-container">
                    <div class="multichar-option-add"><i class="fa-solid fa-plus"></i></div>
                    <div class="multichar-option-info"><i class="fa-regular fa-circle-question"></i></div>
                    <div class="multichar-option-reload"><i class="fa-solid fa-arrow-rotate-right"></i></div>
                </div>
            </div>
            `

            $('.multichar-container-main').html(NuiString2)

            Selected = false
            SelectedChar = null
            SelectedCharInfo = null
        }, 1500)

        $('.multichar-loading-bar-left').css({'width':'50%'})
        $('.multichar-loading-bar-right').css({'width':'50%'})
        $('.multichar-loading-bar-logo').css({'opacity': '100'})
        $('.multichar-container-main').fadeOut()

        $.post('https://skye_char/CreateChar', JSON.stringify({FirstName : FirstName, LastName : LastName, BirthDate: Birth, Gender: CurrentGender}));
    } else {
        console.log('Failed To Create')
    }
})

$(document).on('click', '.multichar-button-delete', function() {
    if (Selected) {
        $('.multichar-loading-bar-left').css({'width':'50%'})
        $('.multichar-loading-bar-right').css({'width':'50%'})
        $('.multichar-loading-bar-logo').css({'opacity': '100'})
        $('.multichar-container-main').fadeOut()

        setTimeout(function(){
            let NuiString = `
            <div class="multichar-container-main">
                <div class="multichar-info-container">
                    <div class="multichar-info-banner">
                        <div class="multichar-info-banner-text">Kies een karakter</div>
                    </div>
                    <div class="multichar-whiteline"></div>
                    <div class="multichar-buttons">
                        <div class="multichar-button-delete"><div class="multichar-button-text">Verwijder</div></div>
                        <div class="multichar-button-play"><div class="multichar-button-text">Speel</div></div>
                    </div>
                </div>


                <div class="mulitchar-options-container">
                    <div class="multichar-option-add"><i class="fa-solid fa-plus"></i></div>
                    <div class="multichar-option-info"><i class="fa-regular fa-circle-question"></i></div>
                    <div class="multichar-option-reload"><i class="fa-solid fa-arrow-rotate-right"></i></div>
                </div>
            </div>
            `

            $('.multichar-container-main').html(NuiString)

            $.post('https://skye_char/DeleteChar', JSON.stringify({CitizenId : SelectedChar}));

            Selected = false
            SelectedChar = null
            SelectedCharInfo = null
        }, 1000);
    }
})

NoChars = function() {
    $('.multichar-loading-bar-left').css({'width':'0%'})
    $('.multichar-loading-bar-right').css({'width':'0%'})
    $('.multichar-loading-bar-logo').css({'opacity': '0'})

    setTimeout(function(){
        $('.multichar-container-loading').fadeOut()
        $('.multichar-container-add').fadeIn()
        InAddMenu = true
    }, 3500);
}

window.addEventListener('message', function(event) {
    switch(event.data.action) {
        case 'StartMultichar':
            StartMultichar(event.data)
        break;
        case 'SetupMultichar':
            SetupMultichar(event.data)
        break;
        case 'NoChars':
            NoChars()
        break;
    }
});