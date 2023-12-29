let current_request = 0
let pressedKeys = {};

let input_focused = false;
let textarea_focused = false;

let sizes = [
	{
		// type: text
		main_h: "20%",
		main_w: "40%",
		label_h: "8%",
		label_w: "98%",
		text_box_h: "86%",
		text_box_w: "98%"
	},
	{
		// type: small_text
		main_h: "6%",
		main_w: "40%",
		label_h: "35%",
		label_w: "98%",
		text_box_h: "53%",
		text_box_w: "98%"
	},
	{
		// type: number
		main_h: "6%",
		main_w: "10%",
		label_h: "35%",
		label_w: "94%",
		text_box_h: "53%",
		text_box_w: "91%"
	}
];
let current_size = 0;

$(function() {
	window.onkeyup = function(e) { pressedKeys[e.keyCode] = false; };
	window.onkeydown = function(e) { pressedKeys[e.keyCode] = true; };

	window.addEventListener("message", function (event) {
		let item = event.data;

		if (item.show) {
			current_request = item.request;
			let _main_text = $("#main_text");
			let _main_number = $("#main_number");

			_main_text.attr("maxlength", item.maxlength);
			_main_text.val("");
			_main_number.val("");

			if(item.type == "text") {
				SetSize(0);
			} else if (item.type == "small_text") {
				SetSize(1);
			} else if (item.type == "number") {
				SetSize(2);
			}

			$("#title_").html(item.title);
			$(".main").fadeIn("swing");

			input_focused = false;
			textarea_focused = false;
			if(item.type == "text" || item.type == "small_text") {
				_main_text.focus();
			} else if (item.type == "number") {
				_main_number.focus();
			}
		}

		if (item.hide)
			$(".main").fadeOut(0);
	});

	$("input").focusin(function() {
        input_focused = true;
        PostReq(`https://cfx-target/allowmove`, {
            allowmove: "false"
        });
    });

    $("input").focusout(function() {
        input_focused = false;
        if(input_focused == false && textarea_focused == false) {
            PostReq(`https://cfx-target/allowmove`, {
                allowmove: "true"
            });
        }
    });

    $("textarea").focusin(function() {
        textarea_focused = true;
        PostReq(`https://cfx-target/allowmove`, {
            allowmove: "false"
        });
    });

    $("textarea").focusout(function() {
        textarea_focused = false;
        if(input_focused == false && textarea_focused == false) {
            PostReq(`https://cfx-target/allowmove`, {
                allowmove: "true"
            });
        }
    });

	jQuery(document).on("keydown", function (evt) {
		if (evt.keyCode == 27 || (evt.keyCode == 8 && !input_focused && !textarea_focused)) { // pressed ESC to close without submiting
			PostReq(`https://cfx-target/response`, {
				request: current_request,
				value: null,
			});
			$(".main").fadeOut(0);
		}

		if(!pressedKeys[16] && evt.keyCode == 13) { // allows to use shift + enter
			document.getElementById("main_text").disabled=true;

			$(".main").fadeOut(0);

			PostReq(`https://cfx-target/response`, {
				request: current_request,
				value: current_size != 2 ? $("#main_text").val() : $("#main_number").val()
			});

			document.getElementById("main_text").disabled=false;
		}
	});

	SetSize(0);
});

function SetSize(size) {
	current_size = size;
	$(".main").css("height", sizes[size].main_h);
	$(".main").css("width", sizes[size].main_w);
	$(".label").css("height", sizes[size].label_h);
	$(".label").css("width", sizes[size].label_w);
	$(".text-box").css("height", sizes[size].text_box_h);
	$(".text-box").css("width", sizes[size].text_box_w);

	if(size == 0 || size == 1) {
		$("#main_text").show();
		$("#main_number").hide();
		input_focused = false;
	} else {
		$("#main_number").show();
		$("#main_text").hide();
		textarea_focused = false;
	}
}

function PostReq(url, data) {
	let xhr = new XMLHttpRequest();
	xhr.open("POST", url, true);
	xhr.setRequestHeader('Content-Type', 'application/json');
	xhr.send(JSON.stringify(data));
}