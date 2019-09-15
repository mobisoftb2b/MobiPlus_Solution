export function BuildGrid(colums, data){

    if (!$.fn.dataTable) return;

    var table = $('#tlbConcentrationActivity').dataTable({
        'paging': true, // Table pagination
        'ordering': true, // Column ordering
        'info': true, // Bottom left status text
        "scrollX": false,
        'responsive': true, // https://datatables.net/extensions/responsive/examples/
        "oLanguage": {
            "sSearch": "חיפוש:  "
        },    
        aoColumns: colums,
        sAjaxSource: data,
        dom: '<"bottom">rft<"bottom html5buttons"B p><"clear">', ///'<"html5buttons"B>lTfgitp',
        buttons: [
            {extend: 'excel', className: 'btn-sm', title: 'XLS-File'},
            {extend: 'pdf',   className: 'btn-sm', title: $('title').text() },
            {extend: 'print', className: 'btn-sm' }
        ]
    });
   
}

export function PopulateGrid(data) { 
    var datatable = $('#tlbConcentrationActivity').dataTable().api();
    datatable.clear();
    datatable.rows.add(data);
    datatable.draw();
}

