{**
 * templates/frontend/components/footer.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Common site frontend footer.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars? This
 *       represents a page-level override, and doesn't indicate whether or not
 *       sidebars have been configured for thesite.
 *}

</div><!-- pkp_structure_content -->

<footer class="footer">

    <div class="container">

        <div class="row">

            <div class="col-md-10">
                {if $pageFooter}
                    {$pageFooter}
                {/if}
            </div>

        </div> <!-- .row -->

         <div class="credit">
            <img src="{$baseUrl}/templates/images/favicon.png">
            {translate key="plugins.themes.vojs.developedBy"}
            <a href="https://vojs.vn/">vojs.vn</a>
        </div>
        
    </div><!-- .container -->
</footer>
</div><!-- pkp_structure_page -->

{load_script context="frontend" scripts=$scripts}

{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>

