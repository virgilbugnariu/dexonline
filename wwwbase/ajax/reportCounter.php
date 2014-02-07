<?php
require_once("../../phplib/util.php");
util_assertModerator(PRIV_EDIT);
util_assertNotMirror();

$reportId = util_getRequestParameter('report');
switch($reportId) {
case 'unassociatedLexems': echo count(Lexem::loadUnassociated()); break;
case 'lexemsWithComments': echo Model::factory('Lexem')->where_not_equal('comment', '')->count(); break;
case 'ambiguousLexems': echo count(Lexem::loadAmbiguous()); break;  // about 0.6s
default: echo 'Necunoscut';
}

?>
