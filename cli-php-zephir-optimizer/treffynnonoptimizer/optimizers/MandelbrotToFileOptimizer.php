<?php

class MandelbrotToFileOptimizer extends OptimizerAbstract
{
    public function optimize(array $expression, Call $call, CompilationContext $context)
    {
	/**
	* Process the expected symbol to be returned
	*/
	$call->processExpectedReturn($context);

	$symbolVariable = $call->getSymbolVariable();
	if ($symbolVariable->isNotVariableAndString()) {
	    throw new CompilerException("Returned values by functions can only be assigned to variant variables", $expression);
	}

	if ($call->mustInitSymbolVariable()) {
	$symbolVariable->initVariant($context);
	}

	$context->headersManager->add('my_mandelbrot');

	$symbolVariable->setDynamicTypes('bool');

	$resolvedParams = $call->getReadOnlyResolvedParams($expression['parameters'], $context, $expression);
	$context->codePrinter->output('ZVAL_BOOL(' . $symbolVariable->getRealName() . ', my_mandelbrot_to_file(' . $resolvedParams[0] . ', ' . $resolvedParams[1] . ', ' . $resolvedParams[2] . ', ' . $resolvedParams[3] . '));');
        return new CompiledExpression('variable', $symbolVariable->getRealName(), $expression);
    }
}
