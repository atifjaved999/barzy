
/*
This is a manifest file that'll be compiled into application.js, which will include all the files
listed below.

Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.

It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
compiled file.

Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
about supported directives.

//= require jquery 
//= require jquery_ujs
*= require admin/jquery.min
*= require admin/bootstrap.min
*= require admin/bootstrap-datepicker
*= require admin/metisMenu.min
*= require admin/jquery.dataTables.min
*= require admin/dataTables.bootstrap.min
*= require admin/dataTables.responsive
*= require admin/sb-admin-2
*= require admin/select2.full.js
*= require admin/fancyBox/source/jquery.fancybox
*= require admin/fancyBox/source/jquery.fancybox.pack
*= require admin/fancyBox/source/helpers/jquery.fancybox-buttons
*= require admin/fancyBox/source/helpers/jquery.fancybox-media
*= require admin/fancyBox/source/helpers/jquery.fancybox-thumbs
//= require jquery_nested_form
//= require jquery.timepicker.js

*= require toastr
*= require admin/custom
*= require admin/raphael.min
*= require admin/morris.min

*/

$(document).ready(function() {
   $('.datepicker').datepicker({ format: 'dd/mm/yyyy' })
    .on('changeDate', function(ev) {
      $(this).datepicker('hide');
   });
 });
