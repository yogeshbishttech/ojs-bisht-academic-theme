<?php
/**
 * @file plugins/themes/bishtAcademicTheme/index.php
 *
 * Copyright (c) 2025-2026 Yogesh Singh Bisht
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *
 * @brief Wrapper for the Bisht Academic Theme plugin.
 */

// Block direct web access. OJS always defines this constant.
if (!defined('INDEX_FILE_LOCATION')) {
	http_response_code(403);
	exit;
}

require_once('BishtAcademicThemePlugin.inc.php');

return new BishtAcademicThemePlugin();
