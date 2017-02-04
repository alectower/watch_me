// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"


window.LogEntries = function() {
  var totalEntries = function() {
    var entry = $(this);
    var entryTotal = parseFloat(entry.data('hours'));
    var totalDiv = $('#total');
    var total = parseFloat(totalDiv.html()) || 0;

    if (entry[0].checked) {
      var newTotal = total + entryTotal;
    } else {
      var newTotal = total - entryTotal;
    }

    totalDiv.html(newTotal.toFixed(4));
  };

  var filterEntries = function() {
    $('#select-all').prop('checked', false);

    var filterVal = $(this).val();

    $('tr.entry').each(function(i, n) {
      var el = $(n);
      var rowText = el.text();

      if (!rowText.match(new RegExp(filterVal, "i"))) {
        el.addClass('hide').css('display', 'none');
      } else {
        el.removeClass('hide').css('display', '');
      }
    });
  };

  return {
    attach: function() {
      $('.include').click(totalEntries);

      $('#select-all').click(function() {
        $('tr').not('.hide')
          .find('.include')
          .trigger('click');
      });

      $('#filter').keyup(filterEntries);
    }
  }
}();

$(function() {
  LogEntries.attach();
});
