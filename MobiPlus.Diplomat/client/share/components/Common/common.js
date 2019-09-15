
    export function TwoLinesTextFormatter(ellvalue, options, rowObject) {        
        if (ellvalue)
            return ellvalue.replace(/\^/g, '\n');
        return '';
    };
    export function ImageFormatter(cellValue, options, rowObject) {
        let src = `../../public/img/${cell}.png`;
        if (cellValue == '')
            return '';
        return "<img src='../../public/img/" + cellValue + ".png' width='25px' />";
    }
    export function BarFormatter(cellValue, options, rowObject) {
        //return "<div className='progress' style='marginTop: 20px'><div className='progress-bar' role='progressbar' aria-valuenow='60' aria-valuemin='0' aria-valuemax='100' style='width:"+ cellValue+"px'>" + cellValue + "</div></div>";
        return "<div style='font-weight:600; width:" + cellValue + "%;background-color:#4F81BD;color:white;font-size:10px;text-align:center;padding-top:3px;padding-bottom:3px;'>" + cellValue + "%</div>";
    }
    export function TwoLinesTextFormatterHtml(ellvalue, options, rowObject) {             
        try {
            if (ellvalue) return ellvalue.replace('^', '<br/>');            
        } catch (e) {
            console.log(e.message);
        }
        return '';
    };
  

