var mySidebar = document.getElementById("mySidebar");
var overlayBg = document.getElementById("myOverlay");
function w3_open() {
    if (mySidebar.style.display === 'block') {
        mySidebar.style.display = 'none';
        overlayBg.style.display = "none";
    } else {
        mySidebar.style.display = 'block';
        overlayBg.style.display = "block";
    }
}
function w3_close() {
    mySidebar.style.display = "none";
    overlayBg.style.display = "none";
}


$(document).ready(function () {
    $('.w3-dropdown-click').each(function () {
        $(this).focusout(function () {
            $(this).children('.w3-dropdown-content').removeClass('w3-show');
        });
        $(this).click(function () {
            $(this).children('.w3-dropdown-content').toggleClass('w3-show');
        });
    });
});
$(document).ready(function () {
    $('.w3-accordion').each(function () {
        $(this).click(function () {
            //$(this).nextAll('.w3-accordion-content:first').toggleClass('w3-hide');
            $(this).find('.w3-accordion-content:first').toggleClass('w3-hide');
        });
    });
});

$(document).ready(function () {
    $('.w3-editor').each(function () {
        ClassicEditor
            .create($(this).get(0), {
                ckfinder: {
                    uploadUrl: '/scripts/ckfinder/core/connector/asp/connector.asp?command=QuickUpload&type=Files&responseType=json'
                }
            })
            .catch(error => {
                console.error(error);
            });
    });
});