$(document).ready(function(){
    
    $('#send_verify').on('click', function(){
        //this.remove();
        var clickedbutton = this;
        $.ajax('/send_email',{
            type:'post',
            context: clickedbutton,
            data: {'user_email': $(this).closest('.card').find('.validate').val()},
            success: send_success,
            error: function(res, ras, ros){console.log(res+ras+ros);},
            beforeSend: function(){
                $(this).addClass('disabled');
                $(this).closest('.card').find('.section_email .validate').attr('disabled',true);
                $(this).closest('.card').find('.preloader-wrapper').addClass('active');
            },
            complete: function(){
                $(this).closest('.card').find('.preloader-wrapper').removeClass('active');
            }
        });
        var user_email = $(this).closest('.card').find('.validate').val();
        
    });
    
    $('#process_verify').on('click', function(){
        //this.remove();
        //alert("in");
        //alert($(this).closest('.card').find('.validate').val());
        var clickedbutton = this;
        $.ajax('/check_code',{
            type:'post',
            context: clickedbutton,
            data: {'user_email': $(this).closest('.card').find('.validate').val(),
                    'user_code':$('#user_code').val()
            },
            success: send_success,
            beforeSend: function(){
                $(this).addClass('disabled');
                $(this).closest('.card').find('.section_email .validate').attr('disabled',true);
                $(this).closest('.card').find('.preloader-wrapper').addClass('active');
            },
            complete: function(){
                $(this).closest('.card').find('.preloader-wrapper').removeClass('active');
            }
        });
        //var user_email = $(this).closest('.card').find('.validate').val();
        
    });
    
});

function alert_success(){
    console.log("ajax success");
}

function send_success(response){
    
    $(this).closest('.card').find('.section_code').show();
    //alert(response.message);
}