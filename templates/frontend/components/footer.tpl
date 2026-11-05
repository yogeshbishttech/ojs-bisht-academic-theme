{**
 * templates/frontend/components/footer.tpl
 *
 * Bisht Academic Theme - Footer Template
 * Copyright (c) 2025-2026 Yogesh Singh Bisht - https://digitalbisht.com/
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *}
</div><!-- .page-container -->

{* Main Footer *}
<footer class="site-footer">
    <div class="container">
        <div class="footer-content">

            {* Column 1: About *}
            <div class="footer-section">
                <h4>About {$currentContext->getLocalizedData('acronym')|default:$currentContext->getLocalizedName()|escape}</h4>
                <p>{$currentContext->getLocalizedDescription()|strip_tags|truncate:200|escape}</p>

                {* Social Media Links (Settings > Website > Appearance > Theme) *}
                {if $bishtSocialLinks}
                <div class="social-links">
                    {foreach from=$bishtSocialLinks item=social}
                        <a href="{$social.url|escape}" class="social-icon" target="_blank" rel="noopener noreferrer" aria-label="{$social.label|escape}"><i class="{$social.icon|escape}" aria-hidden="true"></i></a>
                    {/foreach}
                </div>
                {/if}
            </div>

            {* Column 2: Further Information *}
            <div class="footer-section">
                <h4>Further Information</h4>
                <ul class="footer-links">
                    <li><a href="{url page="about"}">About the Journal</a></li>
                    <li><a href="{url page="about" op="editorialTeam"}">Editorial Team</a></li>
                    <li><a href="{url page="about" op="submissions"}">For Authors</a></li>
                    <li><a href="{url page="about" op="contact"}">Contact Us</a></li>
                    {if $bishtLinks.indexingUrl}
                        <li><a href="{$bishtLinks.indexingUrl|escape}">Indexing</a></li>
                    {/if}
                </ul>
            </div>

            {* Column 3: Explore *}
            <div class="footer-section">
                <h4>Explore</h4>
                <ul class="footer-links">
                    <li><a href="{url page="issue" op="current"}">Current Issue</a></li>
                    <li><a href="{url page="issue" op="archive"}">All Issues</a></li>
                    <li><a href="{url page="announcement"}">Announcements</a></li>
                    <li><a href="{url page="about" op="submissions"}">Article Processing Charges</a></li>
                    {if $bishtLinks.ethicsUrl}
                        <li><a href="{$bishtLinks.ethicsUrl|escape}">Publication Ethics</a></li>
                    {/if}
                </ul>
            </div>

            {* Column 4: Keep up to date *}
            <div class="footer-section">
                <h4>Keep up to date</h4>
                {if $isUserLoggedIn}
                    <p>Manage your email notifications for new issues and announcements in your profile.</p>
                    <a href="{url page="user" op="profile"}" class="btn-subscribe">
                        <i class="fas fa-bell" aria-hidden="true"></i> Notification settings
                    </a>
                {else}
                    <p>Register with the journal to get an email when a new issue is published.</p>
                    <a href="{url page="user" op="register"}" class="btn-subscribe">
                        <i class="fas fa-paper-plane" aria-hidden="true"></i> Register for updates
                    </a>
                {/if}

                {* Indexing Badges (Settings > Website > Appearance > Theme > Indexed In) *}
                {if $bishtIndexedIn}
                <div class="indexing-badges">
                    <h5>Indexed In:</h5>
                    <div class="badges">
                        {foreach from=$bishtIndexedIn item=indexName}
                            <span class="badge">{$indexName|escape}</span>
                        {/foreach}
                    </div>
                </div>
                {/if}
            </div>
        </div>

        {* Custom footer content (Settings > Website > Appearance > Page Footer) *}
        {if $pageFooter}
        <div class="page-footer-content">
            {$pageFooter}
        </div>
        {/if}

        {* Footer Bottom *}
        <div class="footer-bottom">
            <div class="footer-bottom-content">
                <div class="copyright">
                    <p>&copy; {$smarty.now|date_format:"%Y"} {$currentContext->getData('publisherInstitution')|default:$currentContext->getLocalizedName()|escape}</p>
                    {if $currentContext->getLocalizedData('licenseTerms')}
                    <div class="license-terms">{$currentContext->getLocalizedData('licenseTerms')|strip_unsafe_html}</div>
                    {/if}
                    {if $currentContext->getData('mailingAddress')}
                    <p>{$currentContext->getData('mailingAddress')|escape|nl2br}</p>
                    {/if}
                </div>

                {* Theme credit *}
                <div class="developer-credit">
                    <p>Developed by <a href="https://digitalbisht.com/" target="_blank" rel="noopener">Yogesh Singh Bisht</a></p>
                </div>

                {* Powered by OJS *}
                <div class="powered-by">
                    <p>
                        Powered by
                        <a href="https://pkp.sfu.ca/ojs/" target="_blank" rel="noopener">
                            Open Journal Systems
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</footer>

{* Back to Top Button *}
<button id="back-to-top" class="back-to-top" aria-label="Back to top">
    <i class="fas fa-chevron-up" aria-hidden="true"></i>
</button>

{* Load Footer Scripts *}
{load_script context="frontend"}

{call_hook name="Templates::Common::Footer::PageFooter"}

</body>
</html>
