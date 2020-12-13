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
c
<footer class="footer">

    <div class="container">

        <div class="row">

            <div class="col-md-10">
                {if $pageFooter}
                    {$pageFooter}
                {/if}
            </div>

            <div style="text-align: center" class="col-md-2">
                <a href="https://vojs.vn/">
                    <div class="credit">
                        <img src="{$baseUrl}/templates/images/vojs_credit.png">
                    </div>
                </a>
            </div>

        </div> <!-- .row -->
    </div><!-- .container -->
</footer>
</div><!-- pkp_structure_page -->

{load_script context="frontend" scripts=$scripts}

{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
