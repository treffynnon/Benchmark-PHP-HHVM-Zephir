<?php

class MandelbrotToMemOptimizer extends OptimizerAbstract
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

	$symbolVariable->setDynamicTypes('string');

	$resolvedParams = $call->getReadOnlyResolvedParams($expression['parameters'], $context, $expression);
	$context->codePrinter->output('ZVAL_STRING(' . $symbolVariable->getRealName() . ', my_mandelbrot_to_mem(Z_LVAL_P(' . $resolvedParams[0] . '), Z_LVAL_P(' . $resolvedParams[1] . '), Z_BVAL_P(' . $resolvedParams[2] . ')), 1);');
        return new CompiledExpression('variable', $symbolVariable->getRealName(), $expression);
    }
}
