from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    browser=p.chromium.launch(executable_path='/usr/bin/chromium',args=['--no-sandbox'])
    page=browser.new_page(viewport={'width':390,'height':844},is_mobile=True,has_touch=True)
    errors=[]
    page.on('pageerror',lambda e:errors.append(str(e)))
    page.goto('http://127.0.0.1:8765')
    assert page.locator('#empty').is_visible()
    page.locator('#task').fill('   ')
    page.get_by_role('button',name='新增',exact=True).click()
    assert page.locator('li').count()==0
    for text in ['虚构测试：给小花浇水','<img src=x onerror=alert(1)>']:
        page.locator('#task').fill(text)
        page.get_by_role('button',name='新增',exact=True).click()
    assert page.locator('li').count()==2
    assert page.locator('li img').count()==0
    page.get_by_role('checkbox').first.check()
    page.reload()
    assert page.get_by_role('checkbox').first.is_checked()
    assert page.locator('li').count()==2
    page.get_by_role('checkbox').first.uncheck()
    page.reload()
    assert not page.get_by_role('checkbox').first.is_checked()
    page.get_by_role('button',name='删除：<img src=x onerror=alert(1)>',exact=True).click()
    page.reload()
    assert page.locator('li').count()==1
    assert page.evaluate('document.documentElement.scrollWidth <= innerWidth')
    page.screenshot(path='/workspace/NO.1/mobile-preview.png',full_page=True)
    page.get_by_role('button',name='删除：虚构测试：给小花浇水',exact=True).click()
    page.reload()
    assert page.locator('#empty').is_visible()
    page.set_viewport_size({'width':320,'height':700})
    assert page.evaluate('document.documentElement.scrollWidth <= innerWidth')
    assert not errors,errors
    browser.close()
    print('PASS: 新增、空白过滤、完成/取消、删除、刷新保存、文本安全、390/320px 布局；无 JS 错误')
