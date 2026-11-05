{**
 * templates/frontend/pages/article.tpl
 * Bisht Academic Theme - Article Detail Page with Metrics
 * Copyright (c) 2025-2026 Yogesh Singh Bisht - https://digitalbisht.com/
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentPublication->getLocalizedFullTitle()|default:$article->getLocalizedTitle()}

<div class="article-page">
    <div class="container">
        <div class="row">
            {* ================= MAIN CONTENT ================= *}
            <div class="col-md-8">
                <article class="article-detail">
                    {* Breadcrumb *}
                    <nav class="breadcrumb-nav" aria-label="Breadcrumb">
                        <ol class="breadcrumb">
                            <li><a href="{url page="index"}"><i class="fas fa-home"></i> Home</a></li>
                            <li><a href="{url page="issue" op="archive"}">Issues</a></li>
                            {if $issue}
                                <li>
                                    <a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
                                        {$issue->getIssueIdentification()|escape}
                                    </a>
                                </li>
                            {/if}
                            <li class="active">Article</li>
                        </ol>
                    </nav>

                    {* Get current publication *}
                    {assign var=publication value=$article->getCurrentPublication()}
                    {assign var=currentPublication value=$publication}

                    {* Article Section / Type *}
                    {if $publication}
                        {assign var=sectionId value=$publication->getData('sectionId')}
                        {if $sectionId}
                            {assign var=sectionDao value=DAORegistry::getDAO('SectionDAO')}
                            {assign var=section value=$sectionDao->getById($sectionId)}
                            {if $section}
                                <div class="article-type-badge">
                                    {$section->getLocalizedTitle()|escape}
                                </div>
                            {/if}
                        {/if}
                    {/if}

                    {* Article Title *}
                    <h1 class="article-main-title">
                        {$publication->getLocalizedFullTitle()|strip_unsafe_html|default:$article->getLocalizedTitle()|strip_unsafe_html}
                    </h1>

                    {* Subtitle *}
                    {if $publication->getLocalizedData('subtitle')}
                        <h2 class="article-subtitle">
                            {$publication->getLocalizedData('subtitle')|strip_unsafe_html}
                        </h2>
                    {/if}

                    {* Authors *}
                    {assign var=authors value=$publication->getData('authors')|default:$article->getAuthors()}
                    {if $authors && $authors|@count}
                        <div class="article-authors-detail">
                            <h3>Authors</h3>
                            <ul class="authors-list">
                                {foreach from=$authors item=author}
                                    <li class="author-item">
                                        <strong>{$author->getFullName()|escape}</strong>
                                        {if $author->getLocalizedAffiliation()}
                                            <div class="author-affiliation">
                                                {$author->getLocalizedAffiliation()|escape}
                                            </div>
                                        {/if}
                                        {* ORCID URLs are validated in BishtAcademicThemePlugin (orcid.org only) *}
                                        {assign var=authorId value=$author->getId()}
                                        {if isset($bishtOrcidUrls[$authorId])}
                                            <div class="author-orcid">
                                                <a href="{$bishtOrcidUrls[$authorId]|escape}" target="_blank" rel="noopener noreferrer">
                                                    <i class="fab fa-orcid"></i> ORCID
                                                </a>
                                            </div>
                                        {/if}
                                    </li>
                                {/foreach}
                            </ul>
                        </div>

                        {* Manually build author string for citation *}
                        {capture name=authorString}
                            {foreach from=$authors item=author name=authorLoop}
                                {$author->getFullName()|escape}{if !$smarty.foreach.authorLoop.last}, {/if}
                            {/foreach}
                        {/capture}
                    {/if}

                    {* Article Metadata *}
                    <div class="article-metadata-box">
                        {if $publication->getData('datePublished')}
                            <p><strong>Published:</strong> {$publication->getData('datePublished')|date_format:$dateFormatLong}</p>
                        {/if}
                        {assign var=doi value=$publication->getStoredPubId('doi')}
                        {if $doi}
                            <p><strong>DOI:</strong> <a href="https://doi.org/{$doi|escape}" target="_blank" rel="noopener">{$doi|escape}</a></p>
                        {/if}
                        {if $publication->getData('pages')}
                            <p><strong>Pages:</strong> {$publication->getData('pages')|escape}</p>
                        {/if}
                    </div>

                    {* Abstract *}
                    {if $publication->getLocalizedData('abstract')}
                        <div class="article-abstract">
                            <h3>Abstract</h3>
                            {$publication->getLocalizedData('abstract')|strip_unsafe_html}
                        </div>
                    {/if}

                    {* Keywords *}
                    {assign var=keywords value=$publication->getLocalizedData('subject')}
                    {if $keywords}
                        <div class="article-keywords">
                            <h4>Keywords</h4>
                            {assign var=keywordList value=", "|explode:$keywords}
                            {foreach from=$keywordList item=keyword}
                                <span class="keyword-badge">{$keyword|trim|escape}</span>
                            {/foreach}
                        </div>
                    {/if}

                    {* Galleys / Downloads *}
                    {assign var=galleys value=$article->getGalleys()}
                    {if $galleys}
                        <div class="article-downloads">
                            <h3>Downloads</h3>
                            {foreach from=$galleys item=galley}
                                <a class="btn btn-primary" href="{url page="article" op="download" path=$article->getBestId()|to_array:$galley->getBestGalleyId()}" target="_blank" rel="noopener">
                                    <i class="fas fa-download"></i> Download {$galley->getGalleyLabel()|escape}
                                </a>
                            {/foreach}
                        </div>
                    {/if}

                    {* How to Cite *}
                    <div class="article-citation">
                        <h3>How to Cite</h3>
                        <p>
                            {$smarty.capture.authorString|default:"Author(s)"}.
                            ({$publication->getData('datePublished')|date_format:"%Y"}).
                            {$publication->getLocalizedFullTitle()|strip_unsafe_html}.
                            <em>{$currentJournal->getLocalizedName()|escape}</em>
                            {if $issue}, {$issue->getIssueIdentification()|escape}{/if}
                            {if $publication->getData('pages')}, pp. {$publication->getData('pages')|escape}{/if}.
                            {if $doi} https://doi.org/{$doi|escape}{/if}
                        </p>
                    </div>

                    {* === Metrics Section (Simple Design) === *}
                    {if $doi}
                        <div class="article-metrics">
                            <h3>Metrics</h3>
                            <div class="metrics-grid">

                                {* Abstract Views *}
                                {if $article->getViews()}
                                    <div class="metric-item">
                                        <i class="fas fa-eye"></i>
                                        <span class="metric-label">Abstract Views</span>
                                        <strong>{$article->getViews()}</strong>
                                    </div>
                                {/if}

                                {* Total PDF Downloads *}
                                {assign var=totalDownloads value=0}
                                {foreach from=$galleys item=galley}
                                    {math equation="x + y" x=$totalDownloads y=$galley->getViews()|default:0 assign=totalDownloads}
                                {/foreach}
                                {if $totalDownloads > 0}
                                    <div class="metric-item">
                                        <i class="fas fa-download"></i>
                                        <span class="metric-label">File Downloads</span>
                                        <strong>{$totalDownloads}</strong>
                                    </div>
                                {/if}

                                {if $bishtShowMetricBadges}
                                {* Altmetric *}
                                <div class="metric-item">
                                    <span class="metric-label">Altmetric</span>
                                    <div data-badge-type="donut" data-doi="{$doi|escape}" data-hide-no-mentions="true" class="altmetric-embed"></div>
                                </div>

                                {* Dimensions Citations *}
                                <div class="metric-item">
                                    <span class="metric-label">Citations (Dimensions)</span>
                                    <span class="__dimensions_badge_embed__" data-doi="{$doi|escape}" data-style="small_circle" data-legend="none"></span>
                                </div>
                                {/if}

                            </div>
                        </div>

                        {* Third-party badge scripts - only when enabled in the theme settings *}
                        {if $bishtShowMetricBadges}
                        {literal}
                        <script type='text/javascript' src='https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js' async></script>
                        <script async src='https://badge.dimensions.ai/badge.js' charset='utf-8'></script>
                        {/literal}
                        {/if}
                    {/if}

                </article>
            </div>

            {* ================= SIDEBAR ================= *}
            <div class="col-md-4">
                <aside class="article-sidebar">
                    {if $issue}
                        <div class="widget">
                            <h3>Published In</h3>
                            <p>{$issue->getIssueIdentification()|escape}</p>
                            <a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">View Issue</a>
                        </div>
                    {/if}
                    {* License URL is validated in BishtAcademicThemePlugin (http/https only) *}
                    {if $bishtLicenseUrl}
                        <div class="widget">
                            <h3>License</h3>
                            <a href="{$bishtLicenseUrl|escape}" target="_blank" rel="noopener noreferrer license">
                                View License
                            </a>
                        </div>
                    {/if}
                </aside>
            </div>
        </div>
    </div>
</div>

{include file="frontend/components/footer.tpl"}