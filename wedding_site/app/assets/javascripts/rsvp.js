console.log("rsvp.js");
function scroll_to_class(element_class, removed_height) {
	var scroll_to = $(element_class).offset().top - removed_height;
	if($(window).scrollTop() != scroll_to) {
		$('html, body').stop().animate({scrollTop: scroll_to}, 0);
	}
}

function bar_progress(progress_line_object, direction) {
	var number_of_steps = progress_line_object.data('number-of-steps');
	var now_value = progress_line_object.data('now-value');
	var new_value = 0;
	if(direction == 'right') {
		new_value = now_value + ( 100 / number_of_steps );
	}
	else if(direction == 'left') {
		new_value = now_value - ( 100 / number_of_steps );
	}
	progress_line_object.attr('style', 'width: ' + new_value + '%;').data('now-value', new_value);
}

$(document).ready(function() {
    
    $('#top-navbar-1').on('shown.bs.collapse', function(){
    	$.backstretch("resize");
    });
    $('#top-navbar-1').on('hidden.bs.collapse', function(){
    	$.backstretch("resize");
    });
    
    /*
        Form
    */
    $('.f1 fieldset:first').fadeIn('slow');
    
    $('.f1 input[type="text"], .f1 input[type="password"], .f1 textarea').on('focus', function() {
    	$(this).removeClass('input-error');
    });
    
    // next step
    $('.f1 .btn-next').on('click', function() {
        if ($(this).html() == "Finish") {
            document.getElementById("rsvpForm").submit();
        }
        else {
        	var parent_fieldset = $(this).parents('fieldset');
        	var next_step = true;
        	// navigation steps / progress steps
        	var current_active_step = $(this).parents('.f1').find('.f1-step.active');
        	var progress_line = $(this).parents('.f1').find('.f1-progress-line');
        	
        	// fields validation
        	parent_fieldset.find('input[type="text"], input[type="password"], textarea').each(function() {
        		if( $(this).val() == "" ) {
        			$(this).addClass('input-error');
                    $("#guestErrors").html("Required field(s) missing");
        			next_step = false;
        		}
        		else {
        			$(this).removeClass('input-error');
        		}
        	});
        	// fields validation
        	
        	if( next_step ) {
        		parent_fieldset.fadeOut(400, function() {
        			// change icons
        			current_active_step.removeClass('active').addClass('activated').next().addClass('active');
        			// progress bar
        			bar_progress(progress_line, 'right');
        			// show next step
    	    		$(this).next().fadeIn();
    	    		// scroll window to beginning of the form
        			scroll_to_class( $('.f1'), 20 );
    	    	});
        	}
        }
    	
    });
    
    // previous step
    $('.f1 .btn-previous').on('click', function() {
    	// navigation steps / progress steps
    	var current_active_step = $(this).parents('.f1').find('.f1-step.active');
    	var progress_line = $(this).parents('.f1').find('.f1-progress-line');
    	
    	$(this).parents('fieldset').fadeOut(400, function() {
    		// change icons
    		current_active_step.removeClass('active').prev().removeClass('activated').addClass('active');
    		// progress bar
    		bar_progress(progress_line, 'left');
    		// show previous step
    		$(this).prev().fadeIn();
    		// scroll window to beginning of the form
			scroll_to_class( $('.f1'), 20 );
    	});
    });
    
    // submit
    $('.f1').on('submit', function(e) {
    	
    	// fields validation
    	$(this).find('input[type="text"], input[type="password"], textarea').each(function() {
    		if( $(this).val() == "" ) {
    			e.preventDefault();
    			$(this).addClass('input-error');
    		}
    		else {
    			$(this).removeClass('input-error');
    		}
    	});
    	// fields validation

        console.log("Form submission");
    	
    });

    var template = "<div class=\"form-group\" id=\"guest%INDEX%\">\
                        <span style=\"cursor:pointer\" name=\"guestDelete\" index=\"%INDEX%\" id=\"guestDelete%INDEX%\" class=\"glyphicon glyphicon-trash\"></span>\
                            <label id=\"labGuest%INDEX%\" style=\"padding-left:3px\">Guest %INDEX%</label><br />\
                        <input type=\"text\" placeholder=\"First name\" name=\"guests[%INDEX%][first]\">\
                        <input type=\"text\" placeholder=\"Last name\" name=\"guests[%INDEX%][last]\">\
                    </div>";
    
    var index = 1;
    $("#addGuest").on("click", function() {
        if (index > 4) {
            alert("You may only bring up to 4 guests.");
            return;
        }
        var compiled = template.replace(new RegExp("%INDEX%", 'g'), index.toString());
        $("#guests").append(compiled);

        index++;
    });

    $("#guests").on("click", "[name='guestDelete']", function() {
        var removedIndex = parseInt(this.getAttribute("index"));
        $("#guest" + removedIndex).remove();

        for (i = removedIndex+1; i <= 4; i++) {
            $("#guestDelete" + i).attr("index", (i-1));
            $("#guestDelete" + i).attr("id", "guestDelete" + (i-1));
            $("#labGuest" + i).text("Guest " + (i-1));
            $("#labGuest" + i).attr("id", "labGuest" + (i-1));
            $("#guest" + i).attr("id", "guest" + (i-1));
        }
        index--;
        if (index == 1) {
            $(".input-error").each(function() {
                $(this).removeClass("input-error");
            });
            $("#guestErrors").html("");
        }

    });

    $("#guests").on("blur", "input[type='text']", function() {
        console.log("Checking our values.")
        console.log($(this));
        if( $(this).val() != "" ) {
            $(this).removeClass('input-error');
            if ($(".input-error").length == 0) {
                $("#guestErrors").html("");
            }
        }
    });

    $("input[name='rsvpConf']").change(function() {
        var selected = parseInt($("input:radio[name='rsvpConf']:checked").val());
        if (selected == 1) {
            $("#initNext").html("Next");
        }
        else if (selected == 0) {
            $("#initNext").html("Finish");
        }
    });

    var selected = parseInt($("input:radio[name='rsvpConf']:checked").val());
    if (selected == 1) {
        $("#initNext").html("Next");
    }
    else if (selected == 0) {
        $("#initNext").html("Finish");
    }
    
});
