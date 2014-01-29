<?php

class MandelbrotOptimizer extends OptimizerAbstract
{
    public function optimize(array $expression, Call $call, CompilationContext $context)
    {
        $context->headersManager->add('my_mandelbrot');
        $resolvedParams = $call->getReadOnlyResolvedParams($expression['parameters'], $context, $expression);
        return new CompiledExpression('int', 'my_mandelbrot(' . $resolvedParams[0] . ')', $expression);
    }
}
