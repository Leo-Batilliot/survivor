<script>
    let {
        bgColor = 'bg-[#1B3A6B]',
        size = 'w-16 h-16',
        isActive = false,
        ariaLabel = 'Circle button',
        onclick,
        class: extraClass = ''
    } = $props();
</script>

<button type="button" aria-label={ariaLabel} {onclick} class="rounded-full {size} {bgColor} transition-all duration-300 hover:cursor-pointer hover:scale-110{isActive ? ' scale-110 shadow-[0_0_20px_0] shadow-darkblue' : 'opacity-60 hover:opacity-100'} {extraClass}"></button>