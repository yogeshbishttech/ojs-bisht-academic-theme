{**
 * templates/frontend/pages/issue.tpl
 * Bisht Academic Theme - Issue View Page (including Current Issue)
 * Copyright (c) 2025-2026 Yogesh Singh Bisht - https://digitalbisht.com/
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *}

{include file="frontend/components/header.tpl" pageTitleTranslated=$issueIdentification|default:"Current Issue"}

<div class="issue-page">
    <div class="container">
        <div class="row">

            {* ================= MAIN CONTENT ================= *}
            <div class="col-md-8">
                <article class="issue-detail">

                    {* Breadcrumb *}
                    <nav class="breadcrumb-nav" aria-label="Breadcrumb">
                        <ol class="breadcrumb">
                            <li><a href="{url page="index"}"><i class="fas fa-home"></i> Home</a></li>
                            <li><a href="{url page="issue" op="archive"}">Archives</a></li>
                            <li class="active">Current Issue</li>
                        </ol>
                    </nav>

                    {* Check if issue exists *}
                    {if $issue}
                        {* Issue Title/Identification *}
                        <h1 class="issue-main-title">
                            {$issue->getLocalizedTitle()|escape|default:$issue->getIssueIdentification()|escape}
                        </h1>

                        {* Issue Description *}
                        {if $issue->getLocalizedDescription()}
                            <div class="issue-description">
                                {$issue->getLocalizedDescription()|strip_unsafe_html}
                            </div>
                        {/if}

                        {* Table of Contents *}
                        {assign var=publishedArticles value=$publishedSubmissions|default:[]}
                        {if $publishedArticles}
                            <div class="issue-toc">
                                <h2>Table of Contents</h2>
                                {foreach from=$publishedArticles item=section}
                                    {if $section.articles}
                                        {if $section.title}
                                            <h3 class="section-title">{$section.title|escape}</h3>
                                        {/if}
                                        <ul class="articles-list list-unstyled">
                                            {foreach from=$section.articles item=article}
                                                {assign var=publication value=$article->getCurrentPublication()}
                                                {if $publication}
                                                    <li class="article-item media mb-4 p-3 bg-light rounded">
                                                        <div class="media-body">
                                                            <h4 class="mt-0">
                                                                <a href="{url page="article" op="view" path=$article->getBestId()}">
                                                                    {$publication->getLocalizedFullTitle()|strip_unsafe_html}
                                                                </a>
                                                            </h4>

                                                            {* Authors *}
                                                            {assign var=authors value=$publication->getData('authors')}
                                                            {if $authors}
                                                                <div class="article-authors mb-2">
                                                                    {capture name=authorString}
                                                                        {foreach from=$authors item=author name=authorLoop}
                                                                            {$author->getFullName(true)|escape}{if !$smarty.foreach.authorLoop.last}, {/if}
                                                                        {/foreach}
                                                                    {/capture}
                                                                    <strong>By:</strong> {$smarty.capture.authorString}
                                                                </div>
                                                            {/if}

                                                            {* Pages/DOI *}
                                                            {if $publication->getData('pages') || $publication->getStoredPubId('doi')}
                                                                <small class="text-muted d-block mb-2">
                                                                    {if $publication->getData('pages')}Pages: {$publication->getData('pages')|escape}{/if}
                                                                    {assign var=doi value=$publication->getStoredPubId('doi')}
                                                                    {if $doi} | DOI: <a href="https://doi.org/{$doi|escape}" target="_blank" rel="noopener">{$doi|escape}</a>{/if}
                                                                </small>
                                                            {/if}

                                                            {* Abstract Snippet *}
                                                            {if $publication->getLocalizedData('abstract')}
                                                                <div class="article-abstract-snippet mt-2">
                                                                    {$publication->getLocalizedData('abstract')|strip_tags|truncate:300:"..."|escape:"html":"UTF-8":false}
                                                                </div>
                                                            {/if}

                                                            {* Article Downloads *}
                                                            {assign var=galleys value=$article->getGalleys()}
                                                            {if $galleys}
                                                                <div class="article-galleys mt-3">
                                                                    {foreach from=$galleys item=galley}
                                                                        <a href="{url page="article" op="download" path=$article->getBestId()|to_array:$galley->getBestGalleyId()}" class="btn btn-sm btn-primary mr-2">
                                                                            <i class="fas fa-download"></i> {$galley->getGalleyLabel()|escape}
                                                                        </a>
                                                                    {/foreach}
                                                                </div>
                                                            {/if}
                                                        </div>
                                                    </li>
                                                {/if}
                                            {/foreach}
                                        </ul>
                                    {/if}
                                {/foreach}
                            </div>
                        {else}
                            <p class="alert alert-info">No articles are currently published in this issue.</p>
                        {/if}

                        {* Full Issue Downloads *}
                        {if $issueGalleys}
                            <div class="issue-downloads mt-5">
                                <h3>Download Full Issue</h3>
                                {foreach from=$issueGalleys item=galley}
                                    <a class="btn btn-lg btn-success" href="{url page="issue" op="download" path=$issue->getBestIssueId()|to_array:$galley->getBestGalleyId()}" target="_blank" rel="noopener">
                                        <i class="fas fa-file-pdf"></i> {$galley->getGalleyLabel()|escape}
                                    </a>
                                {/foreach}
                            </div>
                        {/if}

                    {else}
                        {* No current issue defined *}
                        <div class="alert alert-warning">
                            <h4>No Current Issue</h4>
                            <p>There is currently no published issue designated as the "current issue".</p>
                            <p><a href="{url page="issue" op="archive"}" class="btn btn-primary">View Issue Archive</a></p>
                        </div>
                    {/if}

                </article>
            </div>

            {* ================= SIDEBAR ================= *}
            <div class="col-md-4">
                <aside class="issue-sidebar">

                    {if $issue}
                        {* Issue Cover *}
                        {if $issue->getLocalizedCoverImageUrl()}
                            <div class="widget text-center mb-4">
                                <img src="{$issue->getLocalizedCoverImageUrl()|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape}" class="img-fluid rounded shadow">
                            </div>
                        {/if}

                        {* Issue Metadata *}
                        <div class="widget">
                            <h3>Issue Information</h3>
                            <ul class="list-unstyled">
                                <li><strong>Published:</strong> {$issue->getDatePublished()|date_format:$dateFormatLong}</li>
                                {if $issue->getVolume()}<li><strong>Volume:</strong> {$issue->getVolume()|escape}</li>{/if}
                                {if $issue->getNumber()}<li><strong>Number:</strong> {$issue->getNumber()|escape}</li>{/if}
                                {if $issue->getYear()}<li><strong>Year:</strong> {$issue->getYear()|escape}</li>{/if}
                            </ul>
                        </div>
                    {/if}

                </aside>
            </div>

        </div>
    </div>
</div>

{include file="frontend/components/footer.tpl"}