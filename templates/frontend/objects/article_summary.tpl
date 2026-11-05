{**
 * templates/frontend/objects/article_summary.tpl
 * Bisht Academic Theme - Article Summary (Search Results, Issue TOC, etc.)
 * Copyright (c) 2025-2026 Yogesh Singh Bisht - https://digitalbisht.com/
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *}

{assign var=article value=$article}
{assign var=publication value=$article->getCurrentPublication()}
{assign var=issue value=$issue|default:null}

<article class="obj_article_summary">
    <h3 class="title">
        <a href="{url page="article" op="view" path=$article->getBestId()}">
            {$publication->getLocalizedFullTitle()|strip_unsafe_html|default:$article->getLocalizedTitle()|strip_unsafe_html}
        </a>
    </h3>

    {* Authors *}
    {assign var=authors value=$publication->getData('authors')}
    {if $authors}
        <div class="authors">
            {foreach from=$authors item=author name=authorLoop}
                {$author->getFullName()|escape}{if !$smarty.foreach.authorLoop.last}, {/if}
            {/foreach}
        </div>
    {/if}

    {* Section Title (Fixed - Safe for OJS 3.3+) *}
    {if $publication}
        {assign var=sectionId value=$publication->getData('sectionId')}
        {if $sectionId}
            {assign var=sectionDao value=DAORegistry::getDAO('SectionDAO')}
            {assign var=section value=$sectionDao->getById($sectionId)}
            {if $section}
                <div class="meta">
                    <span class="section">{$section->getLocalizedTitle()|escape}</span>
                </div>
            {/if}
        {/if}
    {/if}

    {* Issue / Date / Pages *}
    <div class="meta">
        {if $issue}
            {$issue->getIssueIdentification()|escape}
            {if $publication->getData('datePublished')}
                | {$publication->getData('datePublished')|date_format:$dateFormatShort}
            {/if}
        {elseif $publication->getData('datePublished')}
            {$publication->getData('datePublished')|date_format:$dateFormatShort}
        {/if}
        {if $publication->getData('pages')}
            | {$publication->getData('pages')|escape}
        {/if}
    </div>

    {* Abstract Snippet *}
    {if $publication->getLocalizedData('abstract')}
        <div class="abstract">
            {* Plain-text excerpt: truncating HTML could leave tags open *}
            {$publication->getLocalizedData('abstract')|strip_tags|truncate:300:"..."|escape:"html":"UTF-8":false}
        </div>
    {/if}

    {* Galleys / Read More *}
    <div class="galleys_links mt-2">
        <a href="{url page="article" op="view" path=$article->getBestId()}" class="read_more btn btn-sm btn-outline-primary">
            {translate key="common.readMore"}
        </a>
        {assign var=galleys value=$article->getGalleys()}
        {if $galleys}
            {foreach from=$galleys item=galley}
                <a href="{url page="article" op="download" path=$article->getBestId()|to_array:$galley->getBestGalleyId()}" class="btn btn-sm btn-primary ml-2">
                    {$galley->getGalleyLabel()|escape}
                </a>
            {/foreach}
        {/if}
    </div>
</article>