<?php

class MandelbrotOptimizer extends OptimizerAbstract
{
    public function optimize(array $expression, Call $call, CompilationContext $context)
    {
        $context->headersManager->add('mandelbrot.h');
        $resolvedParams = $call->getReadOnlyResolvedParams($expression['parameters'], $context, $expression);
        return new CompiledExpression('int', 'mandelbrot(' . $resolvedParams[0] . ')', $expression);
    }
}
