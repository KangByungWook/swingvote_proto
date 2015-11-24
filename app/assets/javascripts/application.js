// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require spin
//= require jquery_ujs
//= require jquery-ui
//= require jquery-ui/effect.all
//= require jquery-ui/effect
//= require jquery-ui/effect-blind
//= require jquery-ui/effect-bounce
//= require jquery-ui/effect-clip
//= require jquery-ui/effect-drop
//= require jquery-ui/effect-explode
//= require jquery-ui/effect-fade
//= require jquery-ui/effect-fold
//= require jquery-ui/effect-highlight
//= require jquery-ui/effect-puff
//= require jquery-ui/effect-pulsate
//= require jquery-ui/effect-scale
//= require jquery-ui/effect-shake
//= require jquery-ui/effect-size
//= require jquery-ui/effect-slide
//= require jquery-ui/effect-transfer

//= require turbolinks
//= require jqcloud

//= require_tree .

document.addEventListener('page:change', function() {
    document.getElementById('primary-content').className += 'animated fadeIn';
    
});   


spinner = new Spinner({
	lines: 12, // The number of lines to draw
	length: 7, // The length of each line
	width: 5, // The line thickness
	radius: 10, // The radius of the inner circle
	color: '#000', // #rbg or #rrggbb
	speed: 1, // Rounds per second
	trail: 100, // Afterglow percentage
	shadow: true // Whether to render a shadow
})
// 여기 안에 스피너 넣으면 됨
document.addEventListener('page:before-change', function() {
    // document.getElementById('primary-content').innerHTML = "로딩중....";
    // $('#spinnerContainer').after(new Spinner(opts).spin().el);
    // document.getElementById('primary-content').innerHTML = "Hello World!";
    
// 	spinner.spin(document.getElementById("primary-content")); 
	
	document.getElementById("loading").className += "loading";
});

document.addEventListener('page:before-unload', function() {
    // document.getElementById('primary-content').innerHTML = "로딩중....";
    // $('#spinnerContainer').after(new Spinner(opts).spin().el);
    // document.getElementById('primary-content').innerHTML = "Hello World!";
    // spinner.stop(); 
    document.getElementById("loading").className = ' ';
});

function post(path, params, method) {
    method = method || "post"; // Set method to post by default if not specified.

    // The rest of this code assumes you are not using a library.
    // It can be made less wordy if you use one.
    var form = document.createElement("form");
    form.setAttribute("method", method);
    form.setAttribute("action", path);

    for(var key in params) {
        if(params.hasOwnProperty(key)) {
            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", key);
            hiddenField.setAttribute("value", params[key]);

            form.appendChild(hiddenField);
         }
    }

    document.body.appendChild(form);
    form.submit();
}