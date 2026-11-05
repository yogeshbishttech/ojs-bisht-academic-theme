<?php
/**
 * @file plugins/themes/bishtAcademicTheme/BishtAcademicThemePlugin.inc.php
 *
 * Copyright (c) 2025-2026 Yogesh Singh Bisht
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *
 * @class BishtAcademicThemePlugin
 * @ingroup plugins_themes_bishtAcademicTheme
 *
 * @brief Bisht Academic Theme - a free, professional theme for OJS journals.
 *
 * Developed by Yogesh Singh Bisht - https://digitalbisht.com/
 */

// Block direct web access to this file. OJS always defines this constant.
if (!defined('INDEX_FILE_LOCATION')) {
	http_response_code(403);
	exit;
}

if (function_exists('import')) {
	import('lib.pkp.classes.plugins.ThemePlugin');
}

class BishtAcademicThemePlugin extends ThemePlugin {

	/** Social networks that can be linked from the footer: option => [label, Font Awesome icon] */
	const SOCIAL_NETWORKS = [
		'socialFacebook' => ['Facebook', 'fab fa-facebook-f'],
		'socialTwitter' => ['X (Twitter)', 'fab fa-twitter'],
		'socialLinkedin' => ['LinkedIn', 'fab fa-linkedin-in'],
		'socialWhatsapp' => ['WhatsApp', 'fab fa-whatsapp'],
		'socialInstagram' => ['Instagram', 'fab fa-instagram'],
		'socialYoutube' => ['YouTube', 'fab fa-youtube'],
	];

	/** Journal highlight options shown on the homepage */
	const HIGHLIGHT_OPTIONS = ['doiPrefix', 'journalStarted', 'publicationFrequency', 'publicationLanguage', 'apcAmount'];

	/** Links to pages a journal creates itself (e.g. with the Static Pages plugin) */
	const LINK_OPTIONS = ['ethicsUrl', 'indexingUrl', 'googleScholarUrl'];

	/** Longest value accepted from a free-text theme option */
	const MAX_OPTION_LENGTH = 500;

	/**
	 * @copydoc ThemePlugin::init()
	 */
	public function init() {

		$this->setParent('defaultthemeplugin');

		$this->addStyle('bisht-academic-styles', 'styles/index.css');
		$this->addScript('bisht-academic-script', 'js/main.js');

		$this->addStyle(
			'fontawesome',
			'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css',
			['baseUrl' => '']
		);
		$this->addStyle(
			'google-fonts',
			'https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Merriweather:wght@300;400;700&display=swap',
			['baseUrl' => '']
		);

		$this->addMenuArea(['primary', 'user']);

		$this->addOption('colorScheme', 'FieldOptions', [
			'label' => __('plugins.themes.bishtAcademic.option.colorScheme.label'),
			'description' => __('plugins.themes.bishtAcademic.option.colorScheme.description'),
			'type' => 'radio',
			'options' => [
				['value' => 'teal', 'label' => __('plugins.themes.bishtAcademic.option.colorScheme.teal')],
				['value' => 'blue', 'label' => __('plugins.themes.bishtAcademic.option.colorScheme.blue')],
				['value' => 'green', 'label' => __('plugins.themes.bishtAcademic.option.colorScheme.green')],
				['value' => 'purple', 'label' => __('plugins.themes.bishtAcademic.option.colorScheme.purple')],
			],
			'default' => 'teal',
		]);

		$this->addOption('enableSEOFeatures', 'FieldOptions', [
			'label' => __('plugins.themes.bishtAcademic.option.seo.label'),
			'description' => __('plugins.themes.bishtAcademic.option.seo.description'),
			'type' => 'checkbox',
			'options' => [
				['value' => 'structuredData', 'label' => __('plugins.themes.bishtAcademic.option.seo.structuredData')],
				['value' => 'openGraph', 'label' => __('plugins.themes.bishtAcademic.option.seo.openGraph')],
				['value' => 'twitterCards', 'label' => __('plugins.themes.bishtAcademic.option.seo.twitterCards')],
			],
			'default' => ['structuredData', 'openGraph', 'twitterCards'],
		]);

		$this->addOption('showMetricBadges', 'FieldOptions', [
			'label' => __('plugins.themes.bishtAcademic.option.metricBadges.label'),
			'description' => __('plugins.themes.bishtAcademic.option.metricBadges.description'),
			'type' => 'radio',
			'options' => [
				['value' => 'yes', 'label' => __('plugins.themes.bishtAcademic.option.yes')],
				['value' => 'no', 'label' => __('plugins.themes.bishtAcademic.option.no')],
			],
			'default' => 'yes',
		]);

		// Journal highlights. Empty = use the value saved in OJS where OJS has one; "-" = hide.
		foreach (self::HIGHLIGHT_OPTIONS as $optionName) {
			$this->addOption($optionName, 'FieldText', [
				'label' => __('plugins.themes.bishtAcademic.option.' . $optionName . '.label'),
				'description' => __('plugins.themes.bishtAcademic.option.' . $optionName . '.description'),
			]);
		}
		$this->addOption('indexedIn', 'FieldText', [
			'label' => __('plugins.themes.bishtAcademic.option.indexedIn.label'),
			'description' => __('plugins.themes.bishtAcademic.option.indexedIn.description'),
		]);

		// Optional third card in the homepage info section
		$this->addOption('infoCardTitle', 'FieldText', [
			'label' => __('plugins.themes.bishtAcademic.option.infoCardTitle.label'),
			'description' => __('plugins.themes.bishtAcademic.option.infoCardTitle.description'),
		]);
		$this->addOption('infoCardText', 'FieldTextarea', [
			'label' => __('plugins.themes.bishtAcademic.option.infoCardText.label'),
		]);
		$this->addOption('infoCardUrl', 'FieldText', [
			'label' => __('plugins.themes.bishtAcademic.option.infoCardUrl.label'),
			'description' => __('plugins.themes.bishtAcademic.option.url.description'),
		]);

		// Links to journal pages; each link is hidden until a URL is entered
		foreach (self::LINK_OPTIONS as $optionName) {
			$this->addOption($optionName, 'FieldText', [
				'label' => __('plugins.themes.bishtAcademic.option.' . $optionName . '.label'),
				'description' => __('plugins.themes.bishtAcademic.option.url.description'),
			]);
		}

		// Social media profile links (only http/https URLs are accepted)
		foreach (self::SOCIAL_NETWORKS as $optionName => $network) {
			$this->addOption($optionName, 'FieldText', [
				'label' => __('plugins.themes.bishtAcademic.option.social.label', ['network' => $network[0]]),
				'description' => __('plugins.themes.bishtAcademic.option.social.description'),
			]);
		}

		$this->registerHook('TemplateManager::display', [$this, 'loadTemplateData']);
	}

	/**
	 * Register a hook on OJS 3.3 (HookRegistry) or 3.4+ (Hook).
	 * @param string $hookName
	 * @param callable $callback
	 */
	protected function registerHook($hookName, $callback) {
		if (class_exists('\PKP\plugins\Hook')) {
			\PKP\plugins\Hook::add($hookName, $callback);
		} else {
			HookRegistry::register($hookName, $callback);
		}
	}

	/**
	 * Prepare validated data for the theme templates.
	 *
	 * All user-supplied URLs are checked here so the templates never print
	 * a javascript: or data: link, and the JSON-LD block is built with
	 * json_encode() so journal metadata can't break out of the script tag.
	 *
	 * @param string $hookName
	 * @param array $args [TemplateManager, string template]
	 * @return bool
	 */
	public function loadTemplateData($hookName, $args) {
		$templateMgr = $args[0];
		$template = isset($args[1]) ? (string) $args[1] : '';

		try {
			$request = Application::get()->getRequest();
			$context = $request->getContext();

			$seoFeatures = $this->getArrayOption('enableSEOFeatures');
			$article = $templateMgr->getTemplateVars('article');
			$publication = $templateMgr->getTemplateVars('publication');
			if ($article && !$publication) {
				$publication = $article->getCurrentPublication();
			}

			$templateMgr->assign([
				// Works whatever the theme folder is called (e.g. a GitHub "Download ZIP")
				'bishtThemeUrl' => $request->getBaseUrl() . '/' . str_replace('\\', '/', $this->getPluginPath()),
				'bishtShowOpenGraph' => in_array('openGraph', $seoFeatures, true),
				'bishtShowTwitterCards' => in_array('twitterCards', $seoFeatures, true),
				'bishtShowMetricBadges' => $this->getOption('showMetricBadges') !== 'no',
				'bishtSocialLinks' => $this->getSocialLinks(),
				// Highlights are only shown on the journal homepage
				'bishtHighlights' => strpos($template, 'indexJournal') !== false ? $this->getHighlights($context) : [],
				'bishtIndexedIn' => $this->getIndexedIn(),
				'bishtInfoCard' => $this->getInfoCard(),
				'bishtLinks' => $this->getPageLinks(),
				'bishtCanonicalUrl' => $this->getCanonicalUrl($request, $context, $article),
				'bishtOrcidUrls' => $publication ? $this->getOrcidUrls($publication) : [],
				'bishtLicenseUrl' => $this->getLicenseUrl($context, $publication),
				'bishtJsonLd' => ($context && in_array('structuredData', $seoFeatures, true))
					? $this->buildJsonLd($request, $context, $article, $publication, $templateMgr->getTemplateVars('issue'))
					: '',
			]);
		} catch (Throwable $e) {
			// Never break a page because of optional theme data.
			error_log('Bisht Academic Theme: ' . $e->getMessage());
		}

		return false;
	}

	/**
	 * Return an http(s) URL unchanged, or an empty string for anything else
	 * (javascript:, data:, relative paths, malformed values).
	 * @param mixed $url
	 * @param string|null $requiredHost Only accept this host or its subdomains
	 * @return string
	 */
	public static function safeUrl($url, $requiredHost = null) {
		if (!is_string($url)) {
			return '';
		}
		$url = trim($url);
		if ($url === '' || strlen($url) > 2048 || preg_match('/[\x00-\x1F\x7F]/', $url)) {
			return '';
		}
		$parts = parse_url($url);
		if (!$parts || empty($parts['scheme']) || empty($parts['host'])) {
			return '';
		}
		if (!in_array(strtolower($parts['scheme']), ['http', 'https'], true)) {
			return '';
		}
		if ($requiredHost !== null) {
			$host = strtolower($parts['host']);
			if ($host !== $requiredHost && substr($host, -strlen('.' . $requiredHost)) !== '.' . $requiredHost) {
				return '';
			}
		}
		return $url;
	}

	/**
	 * Turn an ORCID value (full URL or bare iD) into a safe orcid.org URL.
	 * @param mixed $orcid
	 * @return string
	 */
	public static function orcidUrl($orcid) {
		if (!is_string($orcid)) {
			return '';
		}
		$orcid = trim($orcid);
		if (preg_match('/^\d{4}-\d{4}-\d{4}-\d{3}[\dX]$/', $orcid)) {
			return 'https://orcid.org/' . $orcid;
		}
		return self::safeUrl($orcid, 'orcid.org');
	}

	/**
	 * Convert HTML to a single line of plain text.
	 * @param mixed $html
	 * @param int $maxLength 0 for no limit
	 * @return string
	 */
	public static function plainText($html, $maxLength = 0) {
		if (!is_string($html) || $html === '') {
			return '';
		}
		$text = strip_tags(preg_replace('/<[^>]*>/', ' $0 ', $html));
		$text = html_entity_decode($text, ENT_QUOTES | ENT_HTML5, 'UTF-8');
		$text = trim(preg_replace('/\s+/u', ' ', $text));
		if ($maxLength > 0 && mb_strlen($text, 'UTF-8') > $maxLength) {
			$text = rtrim(mb_substr($text, 0, $maxLength - 1, 'UTF-8')) . '…';
		}
		return $text;
	}

	/**
	 * Read a free-text theme option as a trimmed, length-limited string.
	 * @param string $name
	 * @return string
	 */
	protected function getTextOption($name, $maxLength = self::MAX_OPTION_LENGTH) {
		$value = $this->getOption($name);
		if (!is_string($value)) {
			return '';
		}
		return mb_substr(trim($value), 0, $maxLength, 'UTF-8');
	}

	/**
	 * Theme option value, or the value OJS already stores when the option is empty.
	 * @param string $name
	 * @param callable $fallback Returns the value from OJS settings
	 * @return string
	 */
	protected function optionOrOjsValue($name, $fallback) {
		$value = $this->getTextOption($name);
		if ($value !== '') {
			return $value;
		}
		try {
			$value = $fallback();
			return is_string($value) ? $value : '';
		} catch (Throwable $e) {
			return '';
		}
	}

	/**
	 * Read a checkbox option as an array, whatever form it was stored in.
	 * @param string $name
	 * @return array
	 */
	protected function getArrayOption($name) {
		$value = $this->getOption($name);
		if (is_string($value)) {
			$decoded = json_decode($value, true);
			$value = is_array($decoded) ? $decoded : ($value === '' ? [] : [$value]);
		}
		return is_array($value) ? array_values($value) : [];
	}

	/**
	 * @return array List of ['label', 'icon', 'url'] for configured networks
	 */
	protected function getSocialLinks() {
		$links = [];
		foreach (self::SOCIAL_NETWORKS as $optionName => $network) {
			$url = self::safeUrl($this->getTextOption($optionName));
			if ($url !== '') {
				$links[] = ['label' => $network[0], 'icon' => $network[1], 'url' => $url];
			}
		}
		return $links;
	}

	/**
	 * @param Context|null $context
	 * @return array List of ['label', 'value'] for the journal highlights box
	 */
	protected function getHighlights($context) {
		$highlights = [];
		$add = function ($labelKey, $value) use (&$highlights) {
			$value = is_string($value) ? trim($value) : '';
			if ($value !== '' && $value !== '-') {
				$highlights[] = ['label' => __('plugins.themes.bishtAcademic.highlight.' . $labelKey), 'value' => $value];
			}
		};

		if ($context) {
			// Settings > Journal > Masthead
			$add('onlineIssn', $context->getData('onlineIssn'));
			$add('printIssn', $context->getData('printIssn'));
		}
		$add('doiPrefix', $this->optionOrOjsValue('doiPrefix', function () use ($context) {
			return $this->getOjsDoiPrefix($context);
		}));
		$add('started', $this->getTextOption('journalStarted'));
		$add('frequency', $this->getTextOption('publicationFrequency'));
		$add('language', $this->optionOrOjsValue('publicationLanguage', function () use ($context) {
			return $this->getOjsLanguages($context);
		}));
		$add('apc', $this->optionOrOjsValue('apcAmount', function () use ($context) {
			return $this->getOjsPublicationFee($context);
		}));
		return $highlights;
	}

	/**
	 * DOI prefix from OJS: the context setting in OJS 3.4+, or the DOI
	 * plugin setting in OJS 3.3 (read from plugin settings, no plugin load).
	 * @param Context|null $context
	 * @return string
	 */
	protected function getOjsDoiPrefix($context) {
		if (!$context) {
			return '';
		}
		$prefix = $context->getData('doiPrefix');
		if (is_string($prefix) && $prefix !== '') {
			return $prefix;
		}
		$pluginSettingsDao = DAORegistry::getDAO('PluginSettingsDAO');
		if (!$pluginSettingsDao || !$pluginSettingsDao->getSetting($context->getId(), 'doipubidplugin', 'enabled')) {
			return '';
		}
		$prefix = $pluginSettingsDao->getSetting($context->getId(), 'doipubidplugin', 'doiPrefix');
		return is_string($prefix) ? $prefix : '';
	}

	/**
	 * Submission languages from Settings > Website > Setup > Languages.
	 * @param Context|null $context
	 * @return string
	 */
	protected function getOjsLanguages($context) {
		if (!$context || !is_callable([$context, 'getSupportedSubmissionLocaleNames'])) {
			return '';
		}
		$names = array_filter((array) $context->getSupportedSubmissionLocaleNames(), 'is_string');
		return implode(', ', $names);
	}

	/**
	 * Publication fee from Settings > Distribution > Payments, when payments are enabled.
	 * @param Context|null $context
	 * @return string e.g. "USD 150"
	 */
	protected function getOjsPublicationFee($context) {
		if (!$context || !$context->getData('paymentsEnabled')) {
			return '';
		}
		$fee = (float) $context->getData('publicationFee');
		if ($fee <= 0) {
			return '';
		}
		$amount = rtrim(rtrim(number_format($fee, 2, '.', ','), '0'), '.');
		$currency = $context->getData('currency');
		return trim((is_string($currency) ? $currency : '') . ' ' . $amount);
	}

	/**
	 * @return array|null ['title', 'text', 'url'] for the optional homepage card
	 */
	protected function getInfoCard() {
		$title = $this->getTextOption('infoCardTitle');
		if ($title === '') {
			return null;
		}
		return [
			'title' => $title,
			'text' => $this->getTextOption('infoCardText', 1000),
			'url' => self::safeUrl($this->getTextOption('infoCardUrl')),
		];
	}

	/**
	 * @return array Option name => safe URL ('' when not set)
	 */
	protected function getPageLinks() {
		$links = [];
		foreach (self::LINK_OPTIONS as $optionName) {
			$links[$optionName] = self::safeUrl($this->getTextOption($optionName));
		}
		return $links;
	}

	/**
	 * @return array Names of indexing services entered by the journal
	 */
	protected function getIndexedIn() {
		$names = array_map('trim', explode(',', $this->getTextOption('indexedIn')));
		return array_values(array_filter($names, 'strlen'));
	}

	/**
	 * Canonical URL for the article and journal home pages only; other
	 * pages get none rather than a wrong one.
	 * @return string
	 */
	protected function getCanonicalUrl($request, $context, $article) {
		if (!$context) {
			return '';
		}
		if ($article) {
			return $request->url(null, 'article', 'view', $article->getBestId());
		}
		$router = $request->getRouter();
		if ($router && method_exists($router, 'getRequestedPage')) {
			$page = $router->getRequestedPage($request);
			if ($page === '' || $page === 'index') {
				return $request->url(null, 'index');
			}
		}
		return '';
	}

	/**
	 * @param Publication $publication
	 * @return array Author ID => safe ORCID URL
	 */
	protected function getOrcidUrls($publication) {
		$urls = [];
		foreach ($publication->getData('authors') ?? [] as $author) {
			$orcid = is_callable([$author, 'getOrcid']) ? $author->getOrcid() : $author->getData('orcid');
			$url = self::orcidUrl($orcid);
			if ($url !== '') {
				$urls[$author->getId()] = $url;
			}
		}
		return $urls;
	}

	/**
	 * @return string Safe license URL of the publication or journal
	 */
	protected function getLicenseUrl($context, $publication) {
		$url = $publication ? self::safeUrl($publication->getData('licenseUrl')) : '';
		if ($url === '' && $context) {
			$url = self::safeUrl($context->getData('licenseUrl'));
		}
		return $url;
	}

	/**
	 * Build the Schema.org JSON-LD script for the journal or article.
	 * @return string
	 */
	protected function buildJsonLd($request, $context, $article, $publication, $issue) {
		$periodical = [
			'@type' => 'Periodical',
			'name' => self::plainText($context->getLocalizedName()),
			'url' => $request->url(null, 'index'),
		];
		$issns = array_values(array_filter([$context->getData('onlineIssn'), $context->getData('printIssn')]));
		if ($issns) {
			$periodical['issn'] = count($issns) === 1 ? $issns[0] : $issns;
		}
		$publisher = self::plainText($context->getData('publisherInstitution'));
		if ($publisher !== '') {
			$periodical['publisher'] = ['@type' => 'Organization', 'name' => $publisher];
		}

		if ($article && $publication) {
			$data = [
				'@context' => 'https://schema.org',
				'@type' => 'ScholarlyArticle',
				'headline' => self::plainText($publication->getLocalizedFullTitle()),
				'url' => $request->url(null, 'article', 'view', $article->getBestId()),
			];
			$abstract = self::plainText($publication->getLocalizedData('abstract'), 500);
			if ($abstract !== '') {
				$data['abstract'] = $abstract;
			}
			$datePublished = $publication->getData('datePublished');
			if ($datePublished && strtotime($datePublished)) {
				$data['datePublished'] = date('Y-m-d', strtotime($datePublished));
			}
			$doi = $publication->getStoredPubId('doi');
			if (is_string($doi) && $doi !== '') {
				$data['identifier'] = 'https://doi.org/' . $doi;
			}
			$authors = [];
			foreach ($publication->getData('authors') ?? [] as $author) {
				$person = ['@type' => 'Person', 'name' => self::plainText($author->getFullName())];
				$affiliation = self::plainText($author->getLocalizedAffiliation());
				if ($affiliation !== '') {
					$person['affiliation'] = ['@type' => 'Organization', 'name' => $affiliation];
				}
				$authors[] = $person;
			}
			if ($authors) {
				$data['author'] = $authors;
			}
			$data['isPartOf'] = $issue
				? ['@type' => 'PublicationIssue', 'name' => self::plainText($issue->getIssueIdentification()), 'isPartOf' => $periodical]
				: $periodical;
		} else {
			$data = ['@context' => 'https://schema.org'] + $periodical;
		}

		// JSON_HEX_* turns < > & ' " into \u escapes, so "</script>" can never appear.
		$json = json_encode(
			$data,
			JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE
				| JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT
		);
		return $json === false ? '' : '<script type="application/ld+json">' . $json . '</script>';
	}

	/**
	 * @copydoc Plugin::getDisplayName()
	 */
	public function getDisplayName() {
		return __('plugins.themes.bishtAcademic.name');
	}

	/**
	 * @copydoc Plugin::getDescription()
	 */
	public function getDescription() {
		return __('plugins.themes.bishtAcademic.description');
	}

	/**
	 * @copydoc ThemePlugin::isActive()
	 */
	public function isActive() {
		if (defined('SESSION_DISABLE_INIT')) {
			return true;
		}
		return parent::isActive();
	}
}
