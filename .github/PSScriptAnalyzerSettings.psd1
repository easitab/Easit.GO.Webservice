@{
    Rules = @{
        PSProvideCommentHelp = @{
            Enable = $true
            ExportedOnly = $false
            BlockComment = $true
            VSCodeSnippetCorrection = $false
            Placement = 'begin'
        }
    }
    ExcludeRules = @(
        'PSReviewUnusedParameter',
        'PSUseShouldProcessForStateChangingFunctions',
        'PSUseDeclaredVarsMoreThanAssignments'
    )
}
