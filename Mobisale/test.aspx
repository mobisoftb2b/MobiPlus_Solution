<%@ Page Language="C#" AutoEventWireup="true" CodeFile="test.aspx.cs" Inherits="test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>תכנון מסלולים</title>
    <script src="scripts/jquery-1.11.0.min.js"></script>
    <script src="scripts/jquery-ui-resizeRight.js"></script>
    <link href="css/Planning.css" rel="stylesheet" />
    <link href="css/fullcalendar.css" rel="stylesheet" />
    <script src="scripts/moment.min.js"></script>
    <script src="scripts/fullcalendar.js"></script>
    <script src="scripts/he.js"></script>
    <style>
        body {
            min-width: 600px;
        }

        .column {
            width: 200px;
            float: left;
            padding-bottom: 100px;
        }

        .portlet {
            margin: 0 1em 1em 0;
            padding: 0.3em;
        }

        .portlet-header {
            padding: 0.2em 0.3em;
            margin-bottom: 0.5em;
            position: relative;
        }

        .portlet-toggle {
            position: absolute;
            top: 50%;
            right: 0;
            margin-top: -8px;
        }

        .portlet-content {
            padding: 0.4em;
        }

        .portlet-placeholder {
            border: 1px dotted black;
            margin: 0 1em 1em 0;
            height: 100px;
        }

        #sortable1, #sortable2, #sortable3, #sortable4, #sortable5, #sortable6 {
            border: 1px solid #eee;
            width: 142px;
            min-height: 20px;
            list-style-type: none;
            margin: 0;
            padding: 5px 0 0 0;
            float: left;
            margin-right: 10px;
        }

            #sortable1 li, #sortable2 li, #sortable3 li, #sortable4 li, #sortable5 li, #sortable6 li {
                margin: 0 5px 5px 5px;
                padding: 5px;
                font-size: 1.2em;
                width: 120px;
            }
    </style>
    <script>
        $(function () {
            //div
            $(".column").sortable({
                connectWith: ".column",
                handle: ".portlet-header",
                cancel: ".portlet-toggle",
                placeholder: "portlet-placeholder ui-corner-all"
            });

            $(".portlet")
              .addClass("ui-widget ui-widget-content ui-helper-clearfix ui-corner-all")
              .find(".portlet-header")
                .addClass("ui-widget-header ui-corner-all")
                .prepend("<span class='ui-icon ui-icon-minusthick portlet-toggle'></span>");

            $(".portlet-toggle").click(function () {
                var icon = $(this);
                icon.toggleClass("ui-icon-minusthick ui-icon-plusthick");
                icon.closest(".portlet").find(".portlet-content").toggle();
            });


            //columns
            $("#sortable1").sortable({
                connectWith: ".connectedSortable",
                remove: function (event, ui) {
                    ui.item.clone().appendTo('#sortable1');
                }
            }).disableSelection();

            $("#sortable2").sortable({
            }).disableSelection();
            $("#sortable3").sortable({
            }).disableSelection();
            $("#sortable4").sortable({
            }).disableSelection();
            $("#sortable5").sortable({
            }).disableSelection();
            $("#sortable6").sortable({
            }).disableSelection();
            $("#sortable7").sortable({
            }).disableSelection();
            $("body").on('dblclick', '#sortable2 .custItem', function () {
                $(this).closest(".custItem").remove();
            });

        });

    </script>
</head>
<body style="direction: rtl;">
    <ul id="sortable1" class="connectedSortable1">
        <li class="ui-state-default custItem">Item 1</li>
        <li class="ui-state-default custItem">Item 2</li>
        <li class="ui-state-default custItem">Item 3</li>
        <li class="ui-state-default custItem">Item 4</li>
        <li class="ui-state-default custItem">Item 5</li>
    </ul>
    <div class="column">

        <div class="portlet">
            <div class="portlet-header">Feeds</div>
            <div class="portlet-content">
                <ul id="sortable2" class="connectedSortable">
                    <li class="ui-state-highlight custItem">Item 1</li>
                    <li class="ui-state-highlight custItem">Item 2</li>
                    <li class="ui-state-highlight custItem">Item 3</li>
                    <li class="ui-state-highlight custItem">Item 4</li>
                    <li class="ui-state-highlight custItem">Item 5</li>
                </ul>
            </div>
        </div>

        <div class="portlet">
            <div class="portlet-header">News</div>
            <ul id="sortable3" class="connectedSortable">
            </ul>
        </div>

    </div>

    <div class="column">

        <div class="portlet">
            <div class="portlet-header">Shopping</div>
            <div class="portlet-content">
                <ul id="sortable4" class="connectedSortable">
                </ul>
            </div>
        </div>

    </div>

    <div class="column">

        <div class="portlet">
            <div class="portlet-header">Links</div>
            <div class="portlet-content">
                <ul id="sortable5" class="connectedSortable">
                </ul>
            </div>
        </div>

        <div class="portlet">
            <div class="portlet-header">Images</div>
            <div class="portlet-content">
                <ul id="sortable6" class="connectedSortable">
                </ul>
            </div>
        </div>
        <div class="portlet">
            <div class="portlet-header">Images</div>
            <div class="portlet-content">
                <ul id="sortable7" class="connectedSortable">
                </ul>
            </div>
        </div>
    </div>















</body>
</html>
