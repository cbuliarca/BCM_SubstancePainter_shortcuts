#include "layerIdAM.jsxinc"
main();


function saveImageFromLayerName( id ){
	multiSelectByIDs(id);


	// =======================================================select transp
	var idsetd = charIDToTypeID( "setd" );
	    var desc11 = new ActionDescriptor();
	    var idnull = charIDToTypeID( "null" );
	        var ref6 = new ActionReference();
	        var idChnl = charIDToTypeID( "Chnl" );
	        var idfsel = charIDToTypeID( "fsel" );
	        ref6.putProperty( idChnl, idfsel );
	    desc11.putReference( idnull, ref6 );
	    var idT = charIDToTypeID( "T   " );
	        var ref7 = new ActionReference();
	        var idChnl = charIDToTypeID( "Chnl" );
	        var idChnl = charIDToTypeID( "Chnl" );
	        var idTrsp = charIDToTypeID( "Trsp" );
	        ref7.putEnumerated( idChnl, idChnl, idTrsp );
	    desc11.putReference( idT, ref7 );
	executeAction( idsetd, desc11, DialogModes.NO );

		// =======================================================crop
	var idCrop = charIDToTypeID( "Crop" );
	    var desc107 = new ActionDescriptor();
	    var idDlt = charIDToTypeID( "Dlt " );
	    desc107.putBoolean( idDlt, true );
	executeAction( idCrop, desc107, DialogModes.NO );


	lname = getNamefromId( id )

	// =======================================================
	var idsave = charIDToTypeID( "save" );
	    var desc138 = new ActionDescriptor();
	    var idAs = charIDToTypeID( "As  " );
	        var desc139 = new ActionDescriptor();
	        var idMthd = charIDToTypeID( "Mthd" );
	        var idPNGMethod = stringIDToTypeID( "PNGMethod" );
	        var idquick = stringIDToTypeID( "quick" );
	        desc139.putEnumerated( idMthd, idPNGMethod, idquick );
	        var idPGIT = charIDToTypeID( "PGIT" );
	        var idPGIT = charIDToTypeID( "PGIT" );
	        var idPGIN = charIDToTypeID( "PGIN" );
	        desc139.putEnumerated( idPGIT, idPGIT, idPGIN );
	        var idPNGf = charIDToTypeID( "PNGf" );
	        var idPNGf = charIDToTypeID( "PNGf" );
	        var idPGAd = charIDToTypeID( "PGAd" );
	        desc139.putEnumerated( idPNGf, idPNGf, idPGAd );
	        var idCmpr = charIDToTypeID( "Cmpr" );
	        desc139.putInteger( idCmpr, 6 );
	    var idPNGF = charIDToTypeID( "PNGF" );
	    desc138.putObject( idAs, idPNGF, desc139 );
	    var idIn = charIDToTypeID( "In  " );
	    var thisJsxPth = File($.fileName).path;

	    desc138.putPath( idIn, new File( thisJsxPth + "\\..\\images\\"+lname+".png" ) );
	    // var idDocI = charIDToTypeID( "DocI" );
	    // desc138.putInteger( idDocI, 195 );
	    var idCpy = charIDToTypeID( "Cpy " );
	    desc138.putBoolean( idCpy, true );
	    var idsaveStage = stringIDToTypeID( "saveStage" );
	    var idsaveStageType = stringIDToTypeID( "saveStageType" );
	    var idsaveSucceeded = stringIDToTypeID( "saveSucceeded" );
	    desc138.putEnumerated( idsaveStage, idsaveStageType, idsaveSucceeded );
	executeAction( idsave, desc138, DialogModes.NO );

	// =======================================================undo
	var idslct = charIDToTypeID( "slct" );
	    var desc173 = new ActionDescriptor();
	    var idnull = charIDToTypeID( "null" );
	        var ref23 = new ActionReference();
	        var idHstS = charIDToTypeID( "HstS" );
	        var idOrdn = charIDToTypeID( "Ordn" );
	        var idPrvs = charIDToTypeID( "Prvs" );
	        ref23.putEnumerated( idHstS, idOrdn, idPrvs );
	    desc173.putReference( idnull, ref23 );
	executeAction( idslct, desc173, DialogModes.NO );

	// =======================================================deselect
	var idsetd = charIDToTypeID( "setd" );
	    var desc182 = new ActionDescriptor();
	    var idnull = charIDToTypeID( "null" );
	        var ref24 = new ActionReference();
	        var idChnl = charIDToTypeID( "Chnl" );
	        var idfsel = charIDToTypeID( "fsel" );
	        ref24.putProperty( idChnl, idfsel );
	    desc182.putReference( idnull, ref24 );
	    var idT = charIDToTypeID( "T   " );
	    var idOrdn = charIDToTypeID( "Ordn" );
	    var idNone = charIDToTypeID( "None" );
	    desc182.putEnumerated( idT, idOrdn, idNone );
	executeAction( idsetd, desc182, DialogModes.NO );


}

function main(){
	selIds = getSelectedLayersIds()
	for(var i=0; i< selIds.length; i++){
		cId = selIds[i];
		vis = isVisibleID( cId);
		if(vis == false){
			// lname = getNamefromId( id )
			saveImageFromLayerName( cId );
		}
	}
}
