{**
 * templates/frontend/pages/indexJournal.tpl
 * Bisht Academic Theme - Journal Homepage
 * Copyright (c) 2025-2026 Yogesh Singh Bisht - https://digitalbisht.com/
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentContext->getLocalizedName()}
</div>

<div id="main-content" class="main-container" role="main">
    <div class="homepage-content herobgcolor">
        <div class="container">
            <section class="hero-section emptyBg">
                <div class="hero-content">
                    <div class="row">
                        <div class="col-md-8">
                            <h1 class="journal-title">
                                {$currentContext->getLocalizedName()|escape}
                            </h1>
                            {if $currentContext->getLocalizedDescription()}
                                <p class="journal-description">
                                    {$currentContext->getLocalizedDescription()|strip_tags|truncate:250|escape:"html":"UTF-8":false}
                                </p>
                            {/if}
                            {if $currentContext->getData('onlineIssn')}
                                <p class="journal-issn">
                                    <strong>Online ISSN:</strong> {$currentContext->getData('onlineIssn')|escape}
                                </p>
                            {/if}
                            <div class="hero-buttons mt-3">
                                <a href="{url page="about" op="submissions"}" class="btn btn-primary">
                                    Submit Manuscript
                                </a>
                                <a href="{url page="issue" op="current"}" class="btn btn-outline-secondary">
                                    Current Issue
                                </a>
                            </div>
                        </div>
                        <div class="col-md-4">
                            {if $bishtHighlights}
                            <div class="rightSideBox">
                                <div class="rightSideBoxTop">
                                    <div class="content">
                                        <div class="metrics_container">
                                            <div class="metrics_tablet">
                                                <div class="card_title border">
                                                    <span class="metric_title">
                                                        <img src="{$bishtThemeUrl|default:"`$baseUrl`/plugins/themes/bishtAcademicTheme"|escape}/images/metric-icon.png" alt=""> Journal highlights
                                                    </span>
                                                </div>
                                                <div class="card_title border">&nbsp;</div>
                                            </div>
                                            <div class="actual-metrics-container has-metrics">
                                                {foreach from=$bishtHighlights item=highlight}
                                                    <div class="card_metrics"><span class="metrics_left">{$highlight.label|escape}</span> <span class="metrics_right">{$highlight.value|escape}</span></div>
                                                {/foreach}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            {/if}
                            <div class="pkp_block block_custom" id="customblock-submission">
                                <h2 class="title pkp_screen_reader">submission</h2>
                                <div class="content">
                                    <p><a href="{url page="about" op="submissions"}">Submit your article <img src="{$bishtThemeUrl|default:"`$baseUrl`/plugins/themes/bishtAcademicTheme"|escape}/images/arrow.png" alt=""></a></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <div class="homepage-content">
        <div class="container">
            {* Info Section: About + optional card + Indexing (cards without content are hidden) *}
            {assign var=infoCardCount value=1}
            {if $bishtInfoCard}{assign var=infoCardCount value=$infoCardCount+1}{/if}
            {if $bishtIndexedIn || $bishtLinks.indexingUrl}
                {assign var=showIndexingCard value=true}
                {assign var=infoCardCount value=$infoCardCount+1}
            {else}
                {assign var=showIndexingCard value=false}
            {/if}
            {if $infoCardCount == 3}{assign var=infoCardClass value="col-md-4"}{elseif $infoCardCount == 2}{assign var=infoCardClass value="col-md-6"}{else}{assign var=infoCardClass value="col-md-12"}{/if}
            <section class="info-section">
                <div class="row">
                    <div class="{$infoCardClass}">
                        <div class="info-card">
                            <div class="icon-wrapper"><i class="fas fa-book-open"></i></div>
                            <h3>About the Journal</h3>
                            <p>{$currentContext->getLocalizedDescription()|strip_tags|truncate:180|escape:"html":"UTF-8":false}</p>
                            <a href="{url page="about"}" class="read-more">Read More <i class="fas fa-arrow-right"></i></a>
                        </div>
                    </div>
                    {* Optional card (Settings > Website > Appearance > Theme > Homepage Card) *}
                    {if $bishtInfoCard}
                    <div class="{$infoCardClass}">
                        <div class="info-card">
                            <div class="icon-wrapper"><i class="fas fa-star"></i></div>
                            <h3>{$bishtInfoCard.title|escape}</h3>
                            {if $bishtInfoCard.text}<p>{$bishtInfoCard.text|escape|nl2br}</p>{/if}
                            {if $bishtInfoCard.url}
                                <a href="{$bishtInfoCard.url|escape}" class="read-more">Read More <i class="fas fa-arrow-right"></i></a>
                            {/if}
                        </div>
                    </div>
                    {/if}
                    {if $showIndexingCard}
                    <div class="{$infoCardClass}">
                        <div class="info-card">
                            <div class="icon-wrapper"><i class="fas fa-list-ul"></i></div>
                            <h3>Indexing and Abstracting</h3>
                            <p>{if $bishtIndexedIn}The journal is indexed and abstracted in {foreach from=$bishtIndexedIn item=indexName name=indexLoop}{$indexName|escape}{if !$smarty.foreach.indexLoop.last}, {/if}{/foreach}.{else}Find out where this journal is indexed and abstracted.{/if}</p>
                            {if $bishtLinks.indexingUrl}
                                <a href="{$bishtLinks.indexingUrl|escape}" class="read-more">Read More <i class="fas fa-arrow-right"></i></a>
                            {/if}
                        </div>
                    </div>
                    {/if}
                </div>
            </section>

            {* Main Content Area *}
            <div class="row main-content-area">
                {* Articles Section - Main Content *}
                <div class="col-md-8">
                    <div class="articles-section">
                        <h2 class="section-title">
                            <i class="fas fa-newspaper"></i> Explore our recent articles
                        </h2>

                        {* Recent Articles (from latest published submissions) *}
                        {if $publishedSubmissions}
                            {foreach from=$publishedSubmissions item=section}
                                {foreach from=$section.articles item=article}
                                    {assign var=publication value=$article->getCurrentPublication()}
                                    {if $publication}
                                        <div class="obj_article_summary home">
                                            <a id="article-{$article->getId()}" href="{url page="article" op="view" path=$article->getBestId()}">
                                                {* Article Section *}
                                                {assign var=sectionId value=$publication->getData('sectionId')}
                                                {if $sectionId}
                                                    {assign var=sectionDao value=DAORegistry::getDAO('SectionDAO')}
                                                    {assign var=sectionObj value=$sectionDao->getById($sectionId)}
                                                    {if $sectionObj}
                                                        <p class="article_section">{$sectionObj->getLocalizedTitle()|escape}</p>
                                                    {/if}
                                                {/if}

                                                {* Article Title *}
                                                <h3 class="title">
                                                    {$publication->getLocalizedFullTitle()|strip_unsafe_html}
                                                </h3>

                                                {* Authors *}
                                                {assign var=authors value=$publication->getData('authors')}
                                                {if $authors}
                                                    <div class="authors">
                                                        <img src="{$bishtThemeUrl|default:"`$baseUrl`/plugins/themes/bishtAcademicTheme"|escape}/images/profile.svg" alt="Authors">
                                                        {foreach from=$authors item=author name=authorLoop}
                                                            {$author->getFullName()|escape}{if !$smarty.foreach.authorLoop.last}, {/if}
                                                        {/foreach}
                                                    </div>
                                                {/if}

                                                {* Volume / Issue / Year / Pages *}
                                                <p class="article_section">
                                                    {if $issue}
                                                        Volume {$issue->getVolume()|escape},
                                                        Issue {$issue->getNumber()|escape},
                                                        {$issue->getYear()|escape}
                                                        {if $publication->getData('pages')}, Pages {$publication->getData('pages')|escape}{/if}
                                                    {/if}
                                                </p>
                                            </a>
                                        </div>
                                    {/if}
                                {/foreach}
                            {/foreach}
                        {else}
                            <p>No articles published yet.</p>
                        {/if}

                        <div class="text-center view-all-wrapper">
                            <a href="{url page="issue" op="archive"}" class="btn btn-outline-primary">
                                <i class="fas fa-archive"></i> View all articles
                            </a>
                        </div>
                    </div>
                </div>

                {* Sidebar *}
                <div class="col-md-4">
                    <aside class="sidebar">
                        {* Journal Highlights Widget *}
                        <div class="widget journal-highlights">
                            <h3><i class="fas fa-chart-line"></i> Journal highlights</h3>
                            {if $bishtHighlights}
                            <ul class="highlight-list">
                                {foreach from=$bishtHighlights item=highlight}
                                    <li><strong>{$highlight.label|escape}:</strong> <span>{$highlight.value|escape}</span></li>
                                {/foreach}
                            </ul>
                            {/if}
                            <a href="{url page="about" op="submissions"}" class="btn btn-block btn-primary">
                                <i class="fas fa-paper-plane"></i> Submit your article
                            </a>
                        </div>

                        {* Find Out More Widget *}
                        <div class="widget find-out-more">
                            <h3><i class="fas fa-info-circle"></i> Find out more</h3>
                            <div class="quick-links">
                                <a href="{url page="about"}"><i class="fas fa-bullseye"></i> Aims &amp; scope</a>
                                <a href="{url page="announcement"}"><i class="fas fa-bullhorn"></i> Call for Papers</a>
                                <a href="{url page="about" op="submissions"}"><i class="fas fa-dollar-sign"></i> Article Processing Charges</a>
                                {if $bishtLinks.ethicsUrl}
                                    <a href="{$bishtLinks.ethicsUrl|escape}"><i class="fas fa-balance-scale"></i> Publication Ethics</a>
                                {/if}
                                {if $bishtLinks.googleScholarUrl}
                                    <a href="{$bishtLinks.googleScholarUrl|escape}" target="_blank" rel="noopener"><i class="fab fa-google"></i> Google Scholar Citations</a>
                                {/if}
                                <a href="{url page="about" op="editorialTeam"}"><i class="fas fa-users"></i> Recruitment</a>
                            </div>
                        </div>

                        {* Current Issue Widget *}
                        {if $issue}
                            <div class="widget current-issue">
                                <h3><i class="fas fa-newspaper"></i> Current Issue</h3>
                                <div class="issue-cover">
                                    {if $issue->getLocalizedCoverImageUrl()}
                                        <img src="{$issue->getLocalizedCoverImageUrl()|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:$issue->getLocalizedTitle()|escape}">
                                    {/if}
                                </div>
                                <h4>{$issue->getIssueIdentification()|escape}</h4>
                                <a href="{url page="issue" op="view" path=$issue->getBestIssueId()}" class="btn btn-sm btn-outline-primary">
                                    View Issue
                                </a>
                            </div>
                        {/if}
                    </aside>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="frontend/components/footer.tpl"}