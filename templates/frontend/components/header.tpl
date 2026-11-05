{**
 * templates/frontend/components/header.tpl
 *
 * Bisht Academic Theme - Header Template
 * Copyright (c) 2025-2026 Yogesh Singh Bisht - https://digitalbisht.com/
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *}
{* OJS pages pass a locale key in $pageTitle; translate it like the default theme does *}
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    
    <title>{$pageTitleTranslated|strip_tags|escape}</title>
    
    {* Basic SEO Meta Tags *}
    <meta name="description" content="{$currentContext->getLocalizedDescription()|strip_tags|escape|truncate:160}">
    <meta name="keywords" content="{$currentContext->getLocalizedData('searchKeywords')|escape}">
    <meta name="author" content="{$currentContext->getData('publisherInstitution')|escape}">
    <meta name="generator" content="Open Journal Systems {$ojsVersion|escape}">
    
    {* Google Scholar Meta Tags *}
    {if $article}
        <meta name="citation_title" content="{$article->getLocalizedTitle()|strip_tags|escape}">
        {foreach from=$article->getAuthors() item=author}
            <meta name="citation_author" content="{$author->getFullName()|escape}">
            {if $author->getLocalizedAffiliation()}
                <meta name="citation_author_institution" content="{$author->getLocalizedAffiliation()|escape}">
            {/if}
        {/foreach}
        
        <meta name="citation_journal_title" content="{$currentContext->getLocalizedName()|escape}">
        
        {if $currentContext->getData('onlineIssn')}
            <meta name="citation_issn" content="{$currentContext->getData('onlineIssn')|escape}">
        {/if}
        {if $currentContext->getData('printIssn')}
            <meta name="citation_issn" content="{$currentContext->getData('printIssn')|escape}">
        {/if}
        
        <meta name="citation_publisher" content="{$currentContext->getData('publisherInstitution')|escape}">
        
        {if $article->getDatePublished()}
            <meta name="citation_publication_date" content="{$article->getDatePublished()|date_format:"%Y/%m/%d"}">
            <meta name="citation_online_date" content="{$article->getDatePublished()|date_format:"%Y/%m/%d"}">
        {/if}
        
        {if $issue}
            {if $issue->getVolume()}
                <meta name="citation_volume" content="{$issue->getVolume()|escape}">
            {/if}
            {if $issue->getNumber()}
                <meta name="citation_issue" content="{$issue->getNumber()|escape}">
            {/if}
        {/if}
        
        {if $article->getPages()}
            {assign var=pages value=$article->getPages()}
            {assign var=pageArray value="-"|explode:$pages}
            {if $pageArray[0]}
                <meta name="citation_firstpage" content="{$pageArray[0]|escape}">
            {/if}
            {if $pageArray[1]}
                <meta name="citation_lastpage" content="{$pageArray[1]|escape}">
            {/if}
        {/if}
        
        {* DOI *}
        {if $article->getStoredPubId('doi')}
            <meta name="citation_doi" content="{$article->getStoredPubId('doi')|escape}">
            <meta name="dc.identifier" content="https://doi.org/{$article->getStoredPubId('doi')|escape}">
        {/if}
        
        {* PDF URL for Google Scholar *}
        {if $article->getGalleys()}
            {foreach from=$article->getGalleys() item=galley}
                {if $galley->isPdfGalley()}
                    <meta name="citation_pdf_url" content="{url page="article" op="download" path=$article->getBestId()|to_array:$galley->getBestGalleyId()}">
                {/if}
            {/foreach}
        {/if}
        
        {* Abstract *}
        {if $article->getLocalizedAbstract()}
            <meta name="citation_abstract" content="{$article->getLocalizedAbstract()|strip_tags|escape|truncate:500}">
            <meta name="dc.description" content="{$article->getLocalizedAbstract()|strip_tags|escape|truncate:500}">
        {/if}
        
        {* Keywords *}
        {if $article->getLocalizedSubject()}
            <meta name="citation_keywords" content="{$article->getLocalizedSubject()|escape}">
        {/if}
        
        {* Language *}
        <meta name="citation_language" content="{$article->getLocale()|replace:"_":"-"}">
        
        {* Full Text URL *}
        <meta name="citation_fulltext_html_url" content="{url page="article" op="view" path=$article->getBestId()}">
        <meta name="citation_abstract_html_url" content="{url page="article" op="view" path=$article->getBestId()}">
    {/if}
    
    {* Dublin Core Meta Tags *}
    <meta name="dc.title" content="{$pageTitleTranslated|strip_tags|escape}">
    <meta name="dc.creator" content="{$currentContext->getData('publisherInstitution')|escape}">
    <meta name="dc.subject" content="{$currentContext->getLocalizedData('searchKeywords')|escape}">
    <meta name="dc.description" content="{$currentContext->getLocalizedDescription()|strip_tags|escape}">
    <meta name="dc.publisher" content="{$currentContext->getData('publisherInstitution')|escape}">
    <meta name="dc.language" content="{$currentLocale|replace:"_":"-"}">
    <meta name="dc.type" content="Text.Serial.Journal">
    <meta name="dc.format" content="text/html">
    
    {if $currentContext->getData('onlineIssn')}
        <meta name="dc.identifier" content="urn:ISSN:{$currentContext->getData('onlineIssn')|escape}">
    {/if}
    
    {* Open Graph Meta Tags (Social Media) *}
    {if $bishtShowOpenGraph}
        <meta property="og:site_name" content="{$currentContext->getLocalizedName()|escape}">
        <meta property="og:title" content="{$pageTitleTranslated|strip_tags|escape}">
        <meta property="og:description" content="{$currentContext->getLocalizedDescription()|strip_tags|escape|truncate:200}">
        <meta property="og:type" content="{if $article}article{else}website{/if}">
        {if $bishtCanonicalUrl}
            <meta property="og:url" content="{$bishtCanonicalUrl|escape}">
        {/if}

        {if $displayPageHeaderLogo}
            <meta property="og:image" content="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}">
            <meta property="og:image:alt" content="{$displayPageHeaderLogo.altText|escape|default:$applicationName}">
        {/if}

        {if $article}
            <meta property="article:published_time" content="{$article->getDatePublished()|date_format:"%Y-%m-%d"}">
            <meta property="article:publisher" content="{$currentContext->getData('publisherInstitution')|escape}">
            {foreach from=$article->getAuthors() item=author}
                <meta property="article:author" content="{$author->getFullName()|escape}">
            {/foreach}
        {/if}
    {/if}

    {* Twitter Card Meta Tags *}
    {if $bishtShowTwitterCards}
        <meta name="twitter:card" content="summary_large_image">
        <meta name="twitter:title" content="{$pageTitleTranslated|strip_tags|escape|truncate:70}">
        <meta name="twitter:description" content="{$currentContext->getLocalizedDescription()|strip_tags|escape|truncate:200}">
        {if $displayPageHeaderLogo}
            <meta name="twitter:image" content="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}">
        {/if}
    {/if}

    {* Canonical URL (article and home pages only) *}
    {if $bishtCanonicalUrl}
        <link rel="canonical" href="{$bishtCanonicalUrl|escape}">
    {/if}

    {* Alternative Links for Different Languages *}
    {if $multipleLanguages}
        {foreach from=$supportedLocales item=localeName key=localeKey}
            <link rel="alternate" hreflang="{$localeKey|replace:"_":"-"}" href="{url page="index" locale=$localeKey}">
        {/foreach}
    {/if}
    
    {* RSS Feed *}
    <link rel="alternate" type="application/rss+xml" title="{$currentContext->getLocalizedName()|escape} - RSS Feed" href="{url page="gateway" op="plugin" path="WebFeedGatewayPlugin/rss2"}">
    <link rel="alternate" type="application/atom+xml" title="{$currentContext->getLocalizedName()|escape} - Atom Feed" href="{url page="gateway" op="plugin" path="WebFeedGatewayPlugin/atom"}">
    
    {* Favicon *}
    {if $displayPageHeaderLogo}
        <link rel="icon" href="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}">
        <link rel="apple-touch-icon" href="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}">
    {/if}
    
    {* Preconnect for Performance *}
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://cdnjs.cloudflare.com">
    
    {* Schema.org Structured Data (built and JSON-encoded in BishtAcademicThemePlugin) *}
    {if $bishtJsonLd}
        {$bishtJsonLd}
    {/if}

    {load_header context="frontend"}
    {load_stylesheet context="frontend"}
</head>
<body class="bisht-academic-theme {$activeTheme->getOption('colorScheme')|default:'teal'|escape}-scheme" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

<div id="top"></div>

{* Skip to Content Link (Accessibility) *}
<a href="#main-content" class="sr-only sr-only-focusable">Skip to main content</a>

{* Announcement Bar *}
{if $activeTheme->getOption('showAnnouncementBar')}
<div class="announcement-bar">
    <div class="container">
        <i class="fas fa-bullhorn"></i>
        <span>New issue published! Check out the latest research.</span>
    </div>
</div>
{/if}

{* Top Navigation Bar *}
<nav class="top-navbar" role="navigation" aria-label="User navigation">
    <div class="container">
        <div class="navbar-brand">
            <a href="{url page="index"}" class="brand-link">

                {* Journal Logo (Settings > Website > Appearance > Logo) *}
                {if $displayPageHeaderLogo}
                    <img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" 
                         alt="{$displayPageHeaderLogo.altText|escape|default:$applicationName}" 
                         class="site-logo"
                         width="200"
                         height="50">
                {/if}

                {if !$displayPageHeaderLogo}
                    <span class="site-name">{$currentContext->getLocalizedName()|escape}</span>
                {/if}

            </a>
        </div>

        <div class="navbar-right">
            {if $isUserLoggedIn}
                <a href="{url page="user" op="profile"}" class="btn-user">
                    <i class="fas fa-user" aria-hidden="true"></i>
                    <span>{$loggedInUsername|escape}</span>
                </a>
                <a href="{url page="login" op="signOut"}" class="btn-logout">
                    <i class="fas fa-sign-out-alt" aria-hidden="true"></i>
                    <span>Logout</span>
                </a>
            {else}
                <a href="{url page="user" op="register"}" class="btn-register">
                    <i class="fas fa-user-plus" aria-hidden="true"></i>
                    <span>Register</span>
                </a>
                <a href="{url page="login"}" class="btn-login">
                    <i class="fas fa-sign-in-alt" aria-hidden="true"></i>
                    <span>Login</span>
                </a>
            {/if}

            {* Search Toggle *}
            <button class="search-toggle" aria-label="Toggle search">
                <i class="fas fa-search" aria-hidden="true"></i>
            </button>
        </div>
    </div>
</nav>


{* Search Bar (Hidden by default) *}
<div class="search-container" style="display: none;" role="search">
    <div class="container">
        <form method="get" action="{url page="search" op="search"}">
            <div class="search-wrapper">
                <label for="search-query" class="sr-only">Search</label>
                <input type="text" 
                       id="search-query"
                       name="query" 
                       placeholder="Search articles, authors, keywords..." 
                       class="search-input"
                       aria-label="Search query">
                <button type="submit" class="search-button" aria-label="Submit search">
                    <i class="fas fa-search" aria-hidden="true"></i> 
                    <span>Search</span>
                </button>
                <button type="button" class="search-close" aria-label="Close search">
                    <i class="fas fa-times" aria-hidden="true"></i>
                </button>
            </div>
        </form>
    </div>
</div>

{* Journal Title Banner *}
<header class="journal-banner" role="banner">
    <div class="container">
        <h1 class="journal-title">{$currentContext->getLocalizedName()|escape}</h1>
        {if $currentContext->getLocalizedData('abbreviation')}
        <p class="journal-abbreviation">{$currentContext->getLocalizedData('abbreviation')|escape}</p>
        {/if}
    </div>
</header>

{* Main Navigation Menu *}
<nav class="main-navigation" role="navigation" aria-label="Main navigation">
    <div class="container">
        <button class="mobile-menu-toggle" aria-label="Toggle navigation menu" aria-expanded="false">
            <i class="fas fa-bars" aria-hidden="true"></i> 
            <span>Menu</span>
        </button>
        
        {load_menu name="primary" id="main-nav" ulClass="nav-menu"}
    </div>
</nav>

{* Page Container *}
<div id="main-content" class="container" role="main">
